convert(::Type{JString}, str::AbstractString) = JString(str)
convert(::Type{JObject}, str::AbstractString) = convert(JObject, JString(str))

#Cast java object from S to T . Needed for polymorphic calls
function convert(::Type{JavaObject{T}}, obj::JavaObject{S}) where {T,S}
    if !isConvertible(T, S)
        isnull(obj) && throw(ArgumentError("Cannot convert NULL"))
        realClass = ccall(_jnifun[].GetObjectClass, VoidPtr, (JNIEnvPtr, VoidPtr),
                          _jenv[], obj.ptr)
        #dynamic cast
        isConvertible(T, realClass) || throw_jc_err("Cannot cast java object from $S to $T")
    end
    ptr = ccall(_jnifun[].NewLocalRef, VoidPtr, (JNIEnvPtr, VoidPtr), _jenv[], obj.ptr)
    #println("convert: ", T, ":", ptr)
    checkerr(ptr)
    JavaObject{T}(ptr)
end

#Is java type convertible from S to T.
isConvertible(T, S) =
    ccall(_jnifun[].IsAssignableFrom, jboolean, (JNIEnvPtr, VoidPtr, VoidPtr),
          _jenv[], metaclass(S), metaclass(T)) == JNI_TRUE

isConvertible(T, S::VoidPtr) =
    ccall(_jnifun[].IsAssignableFrom, jboolean, (JNIEnvPtr, VoidPtr, VoidPtr),
          _jenv[], S, metaclass(T)) == JNI_TRUE

unsafe_convert(::Type{VoidPtr}, cls::JavaMetaClass) = cls.ptr

# Get the JNI/C type for a particular Java type
real_jtype(rettype) =
    (issubtype(rettype, JavaObject) || issubtype(rettype, Array) ||
     issubtype(rettype, JavaMetaClass) ? VoidPtr : rettype)

function convert_args(argtypes::Tuple, args...)
    convertedArgs = Array{Int}(undef, length(args))
    savedArgs = Array{Any}(undef, length(args))
    for i in 1:length(args)
        r = convert_arg(argtypes[i], args[i])
        savedArgs[i] = r[1]
        convertedArgs[i] = jvalue(r[2])
    end
    return savedArgs, convertedArgs
end

function convert_arg(argtype::Type{JString}, arg)
    x = convert(JString, arg)
    x, x.ptr
end

function convert_arg(argtype::Type, arg)
    x = convert(argtype, arg)
    x, x
end
function convert_arg(argtype::Type{T}, arg) where {T<:JavaObject}
    x = convert(T, arg)::T
    x, x.ptr
end

for (x, y, z) in [(:jboolean, :(_jnifun[].NewBooleanArray), :(_jnifun[].SetBooleanArrayRegion)),
                  (:jchar, :(_jnifun[].NewCharArray), :(_jnifun[].SetCharArrayRegion)),
                  (:jbyte, :(_jnifun[].NewByteArray), :(_jnifun[].SetByteArrayRegion)),
                  (:jshort, :(_jnifun[].NewShortArray), :(_jnifun[].SetShortArrayRegion)),
                  (:jint, :(_jnifun[].NewIntArray), :(_jnifun[].SetShortArrayRegion)),
                  (:jlong, :(_jnifun[].NewLongArray), :(_jnifun[].SetLongArrayRegion)),
                  (:jfloat, :(_jnifun[].NewFloatArray), :(_jnifun[].SetFloatArrayRegion)),
                  (:jdouble, :(_jnifun[].NewDoubleArray), :(_jnifun[].SetDoubleArrayRegion)) ]
    @eval function convert_arg(argtype::Type{Vector{$x}}, arg)
              carg = convert(argtype, arg)
              len = length(carg)
              arrayptr = ccall($y, VoidPtr, (JNIEnvPtr, jint), _jenv[], len)
              ccall($z, Nothing, (JNIEnvPtr, VoidPtr, jint, jint, Ptr{$x}),
                    _jenv[], arrayptr, 0, len, carg)
              return carg, arrayptr
          end
end

function convert_arg(argtype::Type{Vector{T}}, arg) where T<:JavaObject
    carg = convert(argtype, arg)
    len = length(carg)
    init = carg[1]
    arrayptr = ccall(_jnifun[].NewObjectArray, VoidPtr,
                     (JNIEnvPtr, jint, VoidPtr, VoidPtr),
                     _jenv[], len, metaclass(T), init.ptr)
    for i = 2:len
        ccall(_jnifun[].SetObjectArrayElement, Nothing,
              (JNIEnvPtr, VoidPtr, jint, VoidPtr),
              _jenv[], arrayptr, i-1, carg[i].ptr)
    end
    return carg, arrayptr
end

convert_result(rettype::Type{T}, result) where {T<:JString} = unsafe_string(JString(result))
convert_result(rettype::Type{T}, result) where {T<:JavaObject} = T(result)
convert_result(rettype, result) = result

for (x, y, z) in
    [(:jboolean, :(_jnifun[].GetBooleanArrayElements), :(_jnifun[].ReleaseBooleanArrayElements)),
     (:jchar, :(_jnifun[].GetCharArrayElements), :(_jnifun[].ReleaseCharArrayElements)),
     (:jbyte, :(_jnifun[].GetByteArrayElements), :(_jnifun[].ReleaseByteArrayElements)),
     (:jshort, :(_jnifun[].GetShortArrayElements), :(_jnifun[].ReleaseShortArrayElements)),
     (:jint, :(_jnifun[].GetIntArrayElements), :(_jnifun[].ReleaseIntArrayElements)),
     (:jlong, :(_jnifun[].GetLongArrayElements), :(_jnifun[].ReleaseLongArrayElements)),
     (:jfloat, :(_jnifun[].GetFloatArrayElements), :(_jnifun[].ReleaseFloatArrayElements)),
     (:jdouble, :(_jnifun[].GetDoubleArrayElements), :(_jnifun[].ReleaseDoubleArrayElements))]
    @eval function convert_result(rettype::Type{Vector{$(x)}}, result)
        len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], result)
        arr = ccall($(y), Ptr{$(x)}, (JNIEnvPtr, VoidPtr, Ptr{jboolean}), _jenv[], result, C_NULL)
        jl_arr::Array = deepcopy(unsafe_wrap(Array, arr, Int(len)))
        ccall($(z), Nothing, (JNIEnvPtr, VoidPtr, Ptr{$(x)}, jint), _jenv[], result, arr, 0)
        jl_arr
    end
end


function convert_result(rettype::Type{Vector{JavaObject{T}}}, result) where {T}
    len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], result)

    ret = Array{JavaObject{T}}(undef, len)

    for i = 1:len
        a = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint),
                  _jenv[], result, i-1)
        ret[i] = JavaObject{T}(a)
    end
    ret
end


# covers return types like Vector{Vector{T}}
function convert_result(rettype::Type{Vector{T}}, result) where {T}
    len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], result)

    ret = Array{T}(undef, len)

    for i = 1:len
        a = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint),
                  _jenv[], result, i-1)
        ret[i] = convert_result(T, a)
    end
    ret
end


function convert_result(rettype::Type{Matrix{JavaObject{T}}}, result) where {T}
    len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], result)
    if len == 0
        return Array{T}(undef, 0, 0)
    end
    a_1 = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint), _jenv[],
                result, 0)
    len_1 = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], a_1)
    ret = Array{JavaObject{T}}(undef, len, len_1)
    for i=1:len
        a = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint), _jenv[],
                  result, i-1)
        # check that size of the current subarray is the same as for the first one
        len_a = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], a)
        @assert(len_a == len_1,
                "Size of $(i)th subrarray is $len_a, but size of the 1st subarray was $len_1")
        for j=1:len_1
            x = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint),
                      _jenv[], a, j-1)
            ret[i, j] = JavaObject{T}(x)
        end
    end
    return ret
end


# matrices of primitive types and other arrays
function convert_result(rettype::Type{Matrix{T}}, result) where {T}
    len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], result)
    if len == 0
        return Array{T}(undef, 0,0)
    end
    a_1 = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint), _jenv[],
                result, 0)
    len_1 = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], a_1)
    ret = Array{T}(undef, len, len_1)
    for i=1:len
        a = ccall(_jnifun[].GetObjectArrayElement, VoidPtr, (JNIEnvPtr, VoidPtr, jint), _jenv[],
                  result, i-1)
        # check that size of the current subarray is the same as for the first one
        len_a = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], a)
        @assert(len_a == len_1,
                "Size of $(i)th subrarray is $len_a, but size of the 1st subarray was $len_1")
        ret[i, :] = convert_result(Vector{T}, a)
    end
    return ret
end

_JO(sym::Symbol) = JavaObject{Symbol("java.lang.$sym")}

convert(::Type{jlong}, obj::_JO(:Long)) =
    jcall(obj, "longValue", jlong, ())
convert(::Type{jint}, obj::_JO(:Integer)) =
    jcall(obj, "intValue", jint, ())
convert(::Type{jdouble}, obj::_JO(:Double)) =
    jcall(obj, "doubleValue", jdouble, ())
convert(::Type{jfloat}, obj::_JO(:Float)) =
    jcall(obj, "floatValue", jfloat, ())
convert(::Type{jboolean}, obj::_JO(:Boolean)) =
    jcall(obj, "booleanValue", jboolean, ())


#The second term in this addition is due to the fact that Java converts all times to local time
function convert(::Type{DateTime}, x::@jimport(java.util.Date))
    if isnull(x)
        Dates.DateTime(1970,1,1,0,0,0)
    else
        Dates.unix2datetime(jcall(x, "getTime", jlong, ())/1000) +
            Second(round(div(Dates.value(now() - now(Dates.UTC)),1000)/900)*(900))
    end
end

function convert(::Type{DateTime}, x::JavaObject)
    isnull(x) && return Dates.DateTime(1970,1,1,0,0,0)
    JDate = @jimport(java.util.Date)
    if isConvertible(JDate, x)
        return convert(DateTime, convert(JDate, x))
    elseif isConvertible(@jimport(java.util.Calendar), x)
        return convert(DateTime, jcall(x, "getTime", JDate, ()))
    end
end

function convert(::Type{@jimport(java.util.Properties)}, x::Dict)
    Properties = @jimport(java.util.Properties)
    p = Properties(())
    for (n,v) in x
        jcall(p, "setProperty", @jimport(java.lang.Object), (JString, JString), n, v)
    end
    p
end

function convert(::Type{@jimport(java.util.HashMap)}, K::Type{JavaObject{X}},
                 V::Type{JavaObject{Y}}, x::Dict) where {X,Y}
    Hashmap = @jimport(java.util.HashMap)
    p = Hashmap(())
    for (n, v) in x
        jcall(p, "put", @jimport(java.lang.Object), (JObject, JObject), n, v)
    end
    p
end

convert(::Type{@jimport(java.util.Map)}, K::Type{JavaObject{X}}, V::Type{JavaObject{Y}},
        x::Dict) where {X,Y} =
            convert(@jimport(java.util.Map), convert(@jimport(java.util.HashMap), K, V, x))

function convert(::Type{@jimport(java.util.ArrayList)}, vec::Vector,
                 VT::Type{JavaObject{<:Any}} = JObject)
    ArrayList = @jimport(java.util.ArrayList)
    arrlst = ArrayList(())
    for v in vec
        jcall(arrlst, "add", jboolean, (JObject,), convert(VT, v))
    end
    arrlst
end

convert(::Type{@jimport(java.util.List)}, vec::Vector, VT::Type{JavaObject{<:Any}}=JObject) =
    convert(@jimport(java.util.ArrayList), vec, VT)

# Convert a reference to a java.lang.String into a Julia string. Copies the underlying byte buffer
function unsafe_string(jstr::JString)  #jstr must be a jstring obtained via a JNI call
    #Return empty string to keep type stability. But this is questionable
    isnull(jstr) && return ""
    pIsCopy = Array{jboolean}(undef, 1)
    buf::Ptr{UInt8} = ccall(_jnifun[].GetStringUTFChars, Ptr{UInt8},
                            (JNIEnvPtr, VoidPtr, Ptr{jboolean}), _jenv[], jstr.ptr, pIsCopy)
    str = unsafe_string(buf)
    ccall(_jnifun[].ReleaseStringUTFChars, Nothing, (JNIEnvPtr, VoidPtr, Ptr{UInt8}), _jenv[],
          jstr.ptr, buf)
    str
end

for (x, y, z) in
    [(:jboolean, :(_jnifun[].GetBooleanArrayElements), :(_jnifun[].ReleaseBooleanArrayElements)),
     (:jchar, :(_jnifun[].GetCharArrayElements), :(_jnifun[].ReleaseCharArrayElements)),
     (:jbyte, :(_jnifun[].GetByteArrayElements), :(_jnifun[].ReleaseByteArrayElements)),
     (:jshort, :(_jnifun[].GetShortArrayElements), :(_jnifun[].ReleaseShortArrayElements)),
     (:jint, :(_jnifun[].GetIntArrayElements), :(_jnifun[].ReleaseIntArrayElements)),
     (:jlong, :(_jnifun[].GetLongArrayElements), :(_jnifun[].ReleaseLongArrayElements)),
     (:jfloat, :(_jnifun[].GetFloatArrayElements), :(_jnifun[].ReleaseFloatArrayElements)),
     (:jdouble, :(_jnifun[].GetDoubleArrayElements), :(_jnifun[].ReleaseDoubleArrayElements)) ]
    @eval function convert(::Type{Vector{$(x)}}, obj::JObject)
        len = ccall(_jnifun[].GetArrayLength, jint, (JNIEnvPtr, VoidPtr), _jenv[], obj.ptr)
        arr = ccall($(y), Ptr{$(x)}, (JNIEnvPtr, VoidPtr, Ptr{jboolean}),
                    _jenv[], obj.ptr, C_NULL)
        jl_arr::Array = deepcopy(unsafe_wrap(Array, arr, Int(len)))
        ccall($(z), Nothing, (JNIEnvPtr, VoidPtr, Ptr{$(x)}, jint), _jenv[], obj.ptr, arr, 0)
        return jl_arr
    end
end


function convert(::Type{Vector{T}}, obj::JObject) where {T}
    len = ccall(_jnifun[].GetArrayLength, jint,
               (JNIEnvPtr, VoidPtr), _jenv[], obj.ptr)
    ret = Array{T}(undef, len)
    for i=1:len
        ptr = ccall(_jnifun[].GetObjectArrayElement, VoidPtr,
                    (JNIEnvPtr, VoidPtr, jint), _jenv[], obj.ptr, i-1)
        ret[i] = convert(T, JObject(ptr))
    end
    return ret
end

##Iterator
iterator(obj::JavaObject) = jcall(obj, "iterator", @jimport(java.util.Iterator), ())

"""
Given a `JavaObject{T}` narrows down `T` to a real class of the underlying object.
For example, `JavaObject{:java.lang.Object}` pointing to `java.lang.String`
will be narrowed down to `JavaObject{:java.lang.String}`
"""
function narrow(obj::JavaObject)
    cls = jcall(obj,"getClass", @jimport(java.lang.Class), ())
    nam = jcall(cls, "getName", JString, ())
    convert(JavaObject{Symbol(nam)}, obj)
end

@static if VERSION < v"1.0-"
    Base.start(itr::JavaObject) = true
    function Base.next(itr::JavaObject, state)
        obj = jcall(itr, "next", @jimport(java.lang.Object), ())
        return (narrow(obj), state)
    end
    Base.done(itr::JavaObject, state)  = (jcall(itr, "hasNext", jboolean, ()) == JNI_FALSE)
else
    Base.iterate(itr::JavaObject) = nothing
    function Base.iterate(itr::JavaObject, state=nothing)
        (jcall(itr, "hasNext", jboolean, ()) == JNI_FALSE) && return nothing
        narrow(jcall(itr, "next", @jimport(java.lang.Object), ()), nothing)
    end
end
