getclass(obj::JavaObject) = jcall(obj, "getClass", JClass, ())

function conventional_name(name::AbstractString)
    if startswith(name, "[")
        conventional_name(name[2:end]) * "[]"
    elseif name == "Z"
        "boolean"
    elseif name == "B"
        "byte"
    elseif name == "C"
        "char"
    elseif name == "I"
        "int"
    elseif name == "J"
        "long"
    elseif name == "F"
        "float"
    elseif name == "D"
        "double"
    elseif name == "V"
        "void"
    elseif startswith(name, "L")
        name[2:end-1]
    else
        name
    end
end

"""
```
getname(cls::JClass)
```
Returns the fully qualified name of the java class

### Args
* cls: The JClass object

### Returns
The fully qualified name of the java class
"""
getname(cls::JClass) = conventional_name(jcall(cls, "getName", JString, ()))

"""
```
getname(method::JMethod)
```
Returns the fully qualified name of the java method

### Args
* cls: The JClass method

### Returns
The fully qualified name of the method
"""
getname(method::JMethod) = jcall(method, "getName", JString, ())

"""
```
listmethods(obj::JavaObject)
```
Lists the methods that are available on the java object passed

### Args
* obj: The java object

### Returns
List of methods
"""
listmethods(cls::JClass) = jcall(cls, "getMethods", Vector{JMethod}, ())
listmethods(::Type{JavaObject{C}}) where {C} = listmethods(classforname(string(C)))
listmethods(obj::JavaObject) = listmethods(getclass(obj))

"""
```
listmethods(obj::JavaObject, name::AbstractString)
```
Lists the methods that are available on the java object passed. The methods are filtered based on the name passed

### Args
* obj: The java object
* name: The filter (e.g. method name)

### Returns
List of methods available on the java object and matching the name passed
"""
listmethods(obj::Union{JavaObject{C},Type{JavaObject{C}}}, name::AbstractString) where {C} =
    filter(m -> getname(m) == name, listmethods(obj))

"""
```
getreturntype(method::JMethod)
```
Returns the return type of the java method

### Args
* method: The java method object

### Returns
Returns the type of the return object as a JClass
"""
getreturntype(method::JMethod) = jcall(method, "getReturnType", JClass, ())

"""
```
getparametertypes(method::JMethod)
```
Returns the parameter types of the java method

### Args
* method: The java method object

### Returns
Vector the parametertypes
"""
getparametertypes(method::JMethod) = jcall(method, "getParameterTypes", Vector{JClass}, ())

Base.show(io::IO, method::JMethod) =
    print(io, getname(getreturntype(method)), " ", getname(method), "(",
          join([getname(c) for c in getparametertypes(method)], ", "), ")")

"""
```
classforname(name::String)
```
Create an instance of `Class<name>` (same as `Class.forName(name)` in Java)

### Args
* name: The name of a class to instantiate

### Returns
JavaObject Instance of `Class<name>`
"""
function classforname(name::String)
    thread = jcall(JThread, "currentThread", JThread, ())
    jcall(JClass, "forName", JClass, (JString, jboolean, JClassLoader), name, true,
          jcall(thread, "getContextClassLoader", JClassLoader, ()))
end
