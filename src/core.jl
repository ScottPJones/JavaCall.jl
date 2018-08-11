
# jni_md.h
const jint = Cint
#ifdef _LP64 /* 64-bit Solaris */
# typedef long jlong;
const jlong = Clonglong
const jbyte = Cchar

# jni.h

const jboolean = Cuchar
const jchar = Cushort
const jshort = Cshort
const jfloat = Cfloat
const jdouble = Cdouble
const jsize = jint

const jprimitive = Union{jboolean, jchar, jshort, jfloat, jdouble, jint, jlong}

struct JavaMetaClass{T}
    ptr::VoidPtr
end

#The metaclass, sort of equivalent to a the
JavaMetaClass(T, ptr) = JavaMetaClass{T}(ptr)

mutable struct JavaObject{T}
    ptr::VoidPtr

    function JavaObject{T}(ptr) where {T}
        jobj = new{T}(ptr)
        @static VERSION < v"0.7-" ? finalizer(jobj, deleteref) : finalizer(deleteref, jobj)
        jobj
    end

    JavaObject{T}(argtypes::Tuple, args...) where {T} = jnew(T, argtypes, args...)
end

JavaObject(T, ptr) = JavaObject{T}(ptr)

function deleteref(x::JavaObject)
    (x.ptr == C_NULL || _jenv[] == C_NULL) && return
    ccall(_jnifun[].DeleteLocalRef, Nothing, (JNIEnvPtr, VoidPtr), _jenv[], x.ptr)
    #Safety in case this function is called direcly, rather than at finalize
    x.ptr = C_NULL
    return
end


"""
```
isnull(obj::JavaObject)
```
Checks if the passed JavaObject is null or not

### Args
* obj: The object of type JavaObject

### Returns
true if the passed object is null else false
"""
isnull(obj::JavaObject) = obj.ptr == C_NULL

"""
```
isnull(obj::JavaMetaClass)
```
Checks if the passed JavaMetaClass is null or not

### Args
* obj: The object of type JavaMetaClass

### Returns
true if the passed object is null else false
"""
isnull(obj::JavaMetaClass) = obj.ptr == C_NULL

const JClass  = JavaObject{Symbol("java.lang.Class")}
const JClassLoader = JavaObject{Symbol("java.lang.ClassLoader")}

const JObject = JavaObject{Symbol("java.lang.Object")}
const JMethod = JavaObject{Symbol("java.lang.reflect.Method")}
const JThread = JavaObject{Symbol("java.lang.Thread")}
const JString = JavaObject{Symbol("java.lang.String")}

JString(str::AbstractString) =
    JString(checkerr(ccall(_jnifun[].NewStringUTF, VoidPtr, (JNIEnvPtr, Ptr{UInt8}),
                           _jenv[], convert(String, str))))

# jvalue(v::Integer) = int64(v) << (64-8*sizeof(v))
jvalue(v::Integer) = Int64(v)
jvalue(v::Float32) = jvalue(reinterpret(Int32, v))
jvalue(v::Float64) = jvalue(reinterpret(Int64, v))
jvalue(v::Ptr) = jvalue(Int(v))

function _jimport(juliaclass) 
    for str in [" ", "(", ")"]
        juliaclass = replace(juliaclass, str=>"")
    end
    :(JavaObject{Symbol($juliaclass)})
end

macro jimport(class::Expr)
    juliaclass = sprint(Base.show_unquoted, class)
    _jimport(juliaclass)
end
macro jimport(class::Symbol)
    juliaclass = string(class)
    _jimport(juliaclass)
end
macro jimport(class::AbstractString)
    _jimport(class)
end

const jc_err_no_detail = "Java Exception thrown, but no details could be retrieved from the JVM"

throw_jc_err(msg) = throw(JavaCallError(msg))
throw_jc_err() = throw_jc_err(jc_err_no_detail)

function jnew(T::Symbol, argtypes::Tuple, args...)
    sig = method_signature(Nothing, argtypes...)
    jmethodId = ccall(_jnifun[].GetMethodID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}), _jenv[], metaclass(T),
                      String("<init>"), sig)
    jmethodId == C_NULL && throw_jc_err("No constructor for $T with signature $sig")
    _jcall(metaclass(T), jmethodId, _jnifun[].NewObjectA, JavaObject{T}, argtypes, args...)
end

# Call static methods
function jcall(typ::Type{JavaObject{T}}, method::AbstractString, rettype::Type, argtypes::Tuple,
               args... ) where T
    sig = method_signature(rettype, argtypes...)
    jmethodId = ccall(_jnifun[].GetStaticMethodID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}), _jenv[], metaclass(T),
                      String(method), sig)
    checkerr(jmethodId, true)
    _jcall(metaclass(T), jmethodId, C_NULL, rettype, argtypes, args...)
end

# Call instance methods
function jcall(obj::JavaObject, method::AbstractString, rettype::Type, argtypes::Tuple, args... )
    sig = method_signature(rettype, argtypes...)
    jmethodId = ccall(_jnifun[].GetMethodID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}), _jenv[], metaclass(obj),
                      String(method), sig)
    checkerr(jmethodId, true)
    _jcall(obj, jmethodId, C_NULL, rettype,  argtypes, args...)
end

function jfield(typ::Type{JavaObject{T}}, field::AbstractString, fieldType::Type) where T
    jfieldId = ccall(_jnifun[].GetStaticFieldID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}), _jenv[], metaclass(T),
                      String(field), signature(fieldType))
    checkerr(jfieldId, true)
    _jfield(metaclass(T), jfieldId, fieldType)
end

function jfield(obj::JavaObject, field::AbstractString, fieldType::Type)
    jfieldId = ccall(_jnifun[].GetFieldID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}), _jenv[], metaclass(obj),
                      String(field), signature(fieldType))
    checkerr(jfieldId, true)
    _jfield(obj, jfieldId, fieldType)
end

for (x, y, z) in [(:jboolean, :(_jnifun[].GetBooleanField), :(_jnifun[].GetStaticBooleanField)),
                  (:jchar, :(_jnifun[].GetCharField), :(_jnifun[].GetStaticCharField)),
                  (:jbyte, :(_jnifun[].GetByteField), :(_jnifun[].GetStaticBypeField)),
                  (:jshort, :(_jnifun[].GetShortField), :(_jnifun[].GetStaticShortField)),
                  (:jint, :(_jnifun[].GetIntField), :(_jnifun[].GetStaticIntField)),
                  (:jlong, :(_jnifun[].GetLongField), :(_jnifun[].GetStaticLongField)),
                  (:jfloat, :(_jnifun[].GetFloatField), :(_jnifun[].GetStaticFloatField)),
                  (:jdouble, :(_jnifun[].GetDoubleField), :(_jnifun[].GetStaticDoubleField)) ]

    @eval function _jfield(obj, jfieldId::VoidPtr, fieldType::Type{$(x)})
              callmethod = ifelse( typeof(obj)<:JavaObject, $y , $z )
              result = ccall(callmethod, $x, (JNIEnvPtr, VoidPtr, VoidPtr),
                             _jenv[], obj.ptr, jfieldId)
              checkerr(result)
              convert_result(fieldType, result)
          end
end

function _jfield(obj, jfieldId::VoidPtr, fieldType::Type)
    callmethod = ifelse(typeof(obj)<:JavaObject,
                        _jnifun[].GetObjectField, _jnifun[].GetStaticObjectField)
    result = ccall(callmethod, VoidPtr, (JNIEnvPtr, VoidPtr, VoidPtr),
                   _jenv[], obj.ptr, jfieldId)
    checkerr(result)
    convert_result(fieldType, result)
end

#Generate these methods to satisfy ccall's compile time constant requirement
#_jcall for primitive and Nothing return types
for (x, y, z) in [(:jboolean, :(_jnifun[].CallBooleanMethodA), :(_jnifun[].CallStaticBooleanMethodA)),
                  (:jchar, :(_jnifun[].CallCharMethodA), :(_jnifun[].CallStaticCharMethodA)),
                  (:jbyte, :(_jnifun[].CallByteMethodA), :(_jnifun[].CallStaticByteMethodA)),
                  (:jshort, :(_jnifun[].CallShortMethodA), :(_jnifun[].CallStaticShortMethodA)),
                  (:jint, :(_jnifun[].CallIntMethodA), :(_jnifun[].CallStaticIntMethodA)),
                  (:jlong, :(_jnifun[].CallLongMethodA), :(_jnifun[].CallStaticLongMethodA)),
                  (:jfloat, :(_jnifun[].CallFloatMethodA), :(_jnifun[].CallStaticFloatMethodA)),
                  (:jdouble, :(_jnifun[].CallDoubleMethodA), :(_jnifun[].CallStaticDoubleMethodA)),
                  (:Nothing, :(_jnifun[].CallVoidMethodA), :(_jnifun[].CallStaticVoidMethodA))]
    @eval function _jcall(obj, jmethodId::VoidPtr, callmethod::VoidPtr,
                          rettype::Type{$(x)}, argtypes::Tuple, args...)
              callmethod == C_NULL && (callmethod = ifelse(typeof(obj)<:JavaObject, $y , $z))
              @assert callmethod != C_NULL
              @assert jmethodId != C_NULL
              isnull(obj) && throw_jc_err("Attempt to call method on Java NULL")
              savedArgs, convertedArgs = convert_args(argtypes, args...)
              result = ccall(callmethod, $x, (JNIEnvPtr, VoidPtr, VoidPtr,
                             VoidPtr), _jenv[], obj.ptr, jmethodId, convertedArgs)
              checkerr(result)
              result === nothing ? nothing : convert_result(rettype, result)
        end
end

#_jcall for Object return types
#obj -- receiver - Class pointer or object prointer
#jmethodId -- Java method ID
#callmethod -- the C method pointer to call

function _jcall(obj, jmethodId::VoidPtr, callmethod::VoidPtr, rettype::Type, argtypes::Tuple,
                args...)
    callmethod == C_NULL &&
        (callmethod = ifelse(typeof(obj)<:JavaObject, _jnifun[].CallObjectMethodA,
                             _jnifun[].CallStaticObjectMethodA))
    @assert callmethod != C_NULL
    @assert jmethodId != C_NULL
    isnull(obj) && error("Attempt to call method on Java NULL")
    savedArgs, convertedArgs = convert_args(argtypes, args...)
    result = ccall(callmethod, VoidPtr, (JNIEnvPtr, VoidPtr, VoidPtr, VoidPtr),
                   _jenv[], obj.ptr, jmethodId, convertedArgs)
    #println("_jcall: $rettype, $result")
    convert_result(rettype, checkerr(result))
end


const _jmc_cache = Dict{Symbol, JavaMetaClass}()

function _metaclass(class::Symbol)
    jclass = javaclassname(class)
    jclassptr = ccall(_jnifun[].FindClass, VoidPtr, (JNIEnvPtr, Ptr{UInt8}), _jenv[], jclass)
    jclassptr == C_NULL && throw_jc_err("Class Not Found $jclass")
    return JavaMetaClass(class, jclassptr)
end

function metaclass(class::Symbol)
    haskey(_jmc_cache, class) || (_jmc_cache[class] = _metaclass(class))
    return _jmc_cache[class]
end

metaclass(::Type{JavaObject{T}}) where {T} = metaclass(T)
metaclass(::JavaObject{T}) where {T} = metaclass(T)

javaclassname(class::Symbol) = replace(string(class), "."=>"/")

function checkerr(ptr, allow=false)
    ptr == C_NULL || return ptr
    jnifun = _jnifun[]
    ccall(jnifun.ExceptionCheck, jboolean, (JNIEnvPtr,), _jenv[]) == JNI_TRUE ||
        (allow ? throw_jc_err("Null from Java. Not known how")
         : return nothing) # No exception pending, legitimate NULL returned from Java

    jthrow = ccall(jnifun.ExceptionOccurred, VoidPtr, (JNIEnvPtr,), _jenv[])
    jthrow == C_NULL && throw_jc_err()
    # Print java stackstrace to stdout
    ccall(jnifun.ExceptionDescribe, Nothing, (JNIEnvPtr,), _jenv[])
    ccall(jnifun.ExceptionClear, Nothing, (JNIEnvPtr,), _jenv[])
    jclass = ccall(jnifun.FindClass, VoidPtr, (JNIEnvPtr, Ptr{UInt8}),
                   _jenv[], "java/lang/Throwable")
    jclass == C_NULL && throw_jc_err()
    jmethodId = ccall(jnifun.GetMethodID, VoidPtr,
                      (JNIEnvPtr, VoidPtr, Ptr{UInt8}, Ptr{UInt8}),
                      _jenv[], jclass, "toString", "()Ljava/lang/String;")
    jmethodId == C_NULL && throw_jc_err()
    res = ccall(jnifun.CallObjectMethodA, VoidPtr, (JNIEnvPtr, VoidPtr, VoidPtr, VoidPtr),
                _jenv[], jthrow, jmethodId, C_NULL)
    res == C_NULL && throw_jc_err()
    msg = unsafe_string(JString(res))
    ccall(jnifun.DeleteLocalRef, Nothing, (JNIEnvPtr, VoidPtr), _jenv[], jthrow)
    throw_jc_err("Error calling Java: $msg")
end

#get the JNI signature string for a method, given its
#return type and argument types
function method_signature(rettype, argtypes...)
    s = IOBuffer()
    write(s, "(")
    for arg in argtypes
        write(s, signature(arg))
    end
    write(s, ")", signature(rettype))
    String(take!(s))
end

#get the JNI signature string for a given type
function signature(arg::Type)
    if arg === jboolean
        return "Z"
    elseif arg === jbyte
        return "B"
    elseif arg === jchar
        return "C"
    elseif arg === jshort
        return "S"
    elseif arg === jint
        return "I"
    elseif arg === jlong
        return "J"
    elseif arg === jfloat
        return "F"
    elseif arg === jdouble
        return "D"
    elseif arg === Nothing
        return "V"
    elseif arg <: Array
        dims = "[" ^ ndims(arg)
        return string(dims, signature(eltype(arg)))
    end
end

signature(arg::Type{JavaObject{T}}) where {T} = string("L", javaclassname(T), ";")
