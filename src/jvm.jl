const JNI_VERSION_1_1 = convert(Cint, 0x00010001)
const JNI_VERSION_1_2 = convert(Cint, 0x00010002)
const JNI_VERSION_1_4 = convert(Cint, 0x00010004)
const JNI_VERSION_1_6 = convert(Cint, 0x00010006)
const JNI_VERSION_1_8 = convert(Cint, 0x00010008)

const JNI_TRUE = convert(Cchar, 1)
const JNI_FALSE = convert(Cchar, 0)

# Return Values
const JNI_OK           = convert(Cint, 0)               #/* success */
const JNI_ERR          = convert(Cint, -1)              #/* unknown error */
const JNI_EDETACHED    = convert(Cint, -2)              #/* thread detached from the VM */
const JNI_EVERSION     = convert(Cint, -3)              #/* JNI version error */
const JNI_ENOMEM       = convert(Cint, -4)              #/* not enough memory */
const JNI_EEXIST       = convert(Cint, -5)              #/* VM already created */
const JNI_EINVAL       = convert(Cint, -6)              #/* invalid arguments */

function javahome_winreg()
    try
        keypath = "SOFTWARE\\JavaSoft\\Java Runtime Environment"
        value = querykey(WinReg.HKEY_LOCAL_MACHINE, keypath, "CurrentVersion")
        keypath *= "\\"*value
        return querykey(WinReg.HKEY_LOCAL_MACHINE, keypath, "JavaHome")
    catch
        try
            keypath = "SOFTWARE\\JavaSoft\\Java Development Kit"
            value = querykey(WinReg.HKEY_LOCAL_MACHINE, keypath, "CurrentVersion")
            keypath *= "\\"*value
            return querykey(WinReg.HKEY_LOCAL_MACHINE, keypath, "JavaHome")
        catch
            error("Cannot find an installation of Java in the Windows Registry.  Please install Java from https://java.com/en/download/manual.jsp and subsequently reload JavaCall.")
        end
    end
end

const libname = @static isunix() ? "libjvm" : "jvm"

function findjvm()
    javahomes = Any[]
    libpaths = Any[]

    if haskey(ENV,"JAVA_HOME")
        push!(javahomes,ENV["JAVA_HOME"])
    else
        @static iswindows() ? ENV["JAVA_HOME"] = javahome_winreg() : nothing
        @static iswindows() ? push!(javahomes, ENV["JAVA_HOME"]) : nothing
    end

    fil = "/usr/libexec/java_home"
    isfile(fil) && push!(javahomes, chomp(read(fil, String)))

    fil = "/usr/lib/jvm/default-java/"
    isdir(fil) &&  push!(javahomes, fil)

    push!(libpaths, pwd())
    for n in javahomes
        @static if iswindows()
            push!(libpaths, joinpath(n, "bin", "server"))
            push!(libpaths, joinpath(n, "jre", "bin", "server"))
            push!(libpaths, joinpath(n, "bin", "client"))
        end
        @static if islinux()
            if Sys.WORD_SIZE==64
                push!(libpaths, joinpath(n, "jre", "lib", "amd64", "server"))
                push!(libpaths, joinpath(n, "lib", "amd64", "server"))
	    elseif Sys.WORD_SIZE==32
                push!(libpaths, joinpath(n, "jre", "lib", "i386", "server"))
                push!(libpaths, joinpath(n, "lib", "i386", "server"))
             end
         end
        push!(libpaths, joinpath(n, "jre", "lib", "server"))
        push!(libpaths, joinpath(n, "lib", "server"))
    end

    ext = @static iswindows() ? "dll" : (@static isapple() ? "dylib" : "so")
    ext = "." * ext

    try
        for n in libpaths
            libpath = joinpath(n, libname * ext)
            if isfile(libpath)
                if iswindows()
                    bindir = dirname(dirname(libpath))
                    m = filter(x -> ismatch(r"msvcr(?:.*).dll",x), readdir(bindir))
                    Libdl.dlopen(joinpath(bindir,m[1]))
                end
                global libjvm = Libdl.dlopen(libpath)
                println("Loaded $libpath")
                return
            end
        end
    catch
    end

    errorMsg =
        [
         "Cannot find java library $libname$ext\n",
         "Search Path:"
         ];
    for path in libpaths
        push!(errorMsg,"\n   $path")
    end
    throw_jc_err(reduce(*, errorMsg))
end

struct JavaVMOption
    optionString::Ptr{UInt8}
    extraInfo::VoidPtr
end

struct JavaVMInitArgs
    version::Cint
    nOptions::Cint
    options::Ptr{JavaVMOption}
    ignoreUnrecognized::Cchar
end

@static isunix() ? (const sep = ":") : nothing
@static iswindows() ? (const sep = ";") : nothing

const _classpaths = OrderedSet{String}()
const _options    = OrderedSet{String}()

function addClassPath(str::String)
    println("addClassPath($str)")
    if isloaded()
        @warn("JVM already initialised. This call has no effect")
        return
    end
    str == "" && return
    if endswith(str, "/*") && isdir(str[1:end-2])
        for fn in readdir(s[1:end-2])
            println(fn)
            endswith(fn, ".jar") && push!(_classpaths, str[1:end-1] * fn)
        end
        return
    end
    push!(_classpaths, str)
    return
end

addOpts(s::String) =
    isloaded() ? @warn("JVM already initialised. This call has no effect") : push!(_options, s)

function init()
    if isempty(_classpaths)
        init(_options)
    else
        ccp = collect(_classpaths)
        init(vcat(collect(_options),
                  reduce((x, y)->string(x, sep, y), "-Djava.class.path=$(ccp[1])", ccp[2:end])))
    end
end

assertloaded() = isloaded() ? nothing : throw_jc_err("JVM not initialised. Please run init()")
assertnotloaded() = isloaded() ? throw_jc_err("JVM already initialised") : nothing

const _jvm    = Ref{Ptr{JavaVM}}()
const _jenv   = Ref{JNIEnvPtr}()
const _jvmfun = Ref{Any}()
const _jnifun = Ref{Any}()

isloaded() = isassigned(_jnifun) && isassigned(_jenv) && _jenv[] != C_NULL

# Pointer to pointer to pointer to pointer alert! Hurrah for unsafe load
function init(opts)
    assertnotloaded()
    try
        opt = [JavaVMOption(pointer(x), C_NULL) for x in opts]
        vm_args = JavaVMInitArgs(JNI_VERSION_1_6, convert(Cint, length(opts)),
                                 convert(Ptr{JavaVMOption}, pointer(opt)), JNI_TRUE)
        res = ccall(create_jvm[], Cint, (Ref{Ptr{JavaVM}}, Ref{JNIEnvPtr}, Ref{JavaVMInitArgs}),
                    _jvm, _jenv, Ref(vm_args))
        res < 0 && throw_jc_err("Unable to initialise Java VM: $res")
        jvm = unsafe_load(_jvm[])
        jni = unsafe_load(_jenv[])
        _jvmfun[] = unsafe_load(jvm.JNIInvokeInterface_)
        _jnifun[] = unsafe_load(jni.JNINativeInterface_) #The JNI Function table
        nothing
    catch ex
        println("JavaCall.init($opts): ", sprint(showerror, ex, catch_backtrace()))
        ex
    end
end

function destroy()
    _jenv[] == C_NULL && throw_jc_err("Called destroy without initialising Java VM")
    res = ccall(_jvmfun[].DestroyJavaVM, Cint, (VoidPtr,), pjvm)
    res < 0 && throw_jc_err("Unable to destroy Java VM: $res")
    _jvm[] = _jenv[] = C_NULL
end
