

struct JNINativeInterface #struct JNINativeInterface_ {

    reserved0::VoidPtr # void *reserved0;

    reserved1::VoidPtr #void *reserved1;
    reserved2::VoidPtr #void *reserved2;
    reserved3::VoidPtr #void *reserved3;

    GetVersion::VoidPtr #jint ( *GetVersion)(JNIEnv *env);
    DefineClass::VoidPtr #jclass ( *DefineClass) (JNIEnv *env, const char *name, jobject loader, const jbyte *buf, jsize len);
    FindClass::VoidPtr #jclass ( *FindClass) (JNIEnv *env, const char *name);
    FromReflectedMethod::VoidPtr #jmethodID ( *FromReflectedMethod) (JNIEnv *env, jobject method);
    FromReflectedField::VoidPtr #jfieldID ( *FromReflectedField)(JNIEnv *env, jobject field);
    ToReflectedMethod::VoidPtr #jobject ( *ToReflectedMethod) (JNIEnv *env, jclass cls, jmethodID methodID, jboolean isStatic);

    GetSuperClass::VoidPtr  #jclass ( *GetSuperclass) (JNIEnv *env, jclass sub);
    IsAssignableFrom::VoidPtr #jboolean ( *IsAssignableFrom) (JNIEnv *env, jclass sub, jclass sup);

    ToReflectedField::VoidPtr #jobject ( *ToReflectedField)(JNIEnv *env, jclass cls, jfieldID fieldID, jboolean isStatic);

    Throw::VoidPtr #jint ( *Throw) (JNIEnv *env, jthrowable obj);
    ThrowNew::VoidPtr #jint ( *ThrowNew)(JNIEnv *env, jclass clazz, const char *msg);
    ExceptionOccurred::VoidPtr #jthrowable ( *ExceptionOccurred) (JNIEnv *env);
    ExceptionDescribe::VoidPtr #void ( *ExceptionDescribe)(JNIEnv *env);
    ExceptionClear::VoidPtr #void ( *ExceptionClear) (JNIEnv *env);
    FatalError::VoidPtr #void ( *FatalError) (JNIEnv *env, const char *msg);

    PushLocalFrame::VoidPtr #jint ( *PushLocalFrame) (JNIEnv *env, jint capacity);
    PopLocalFrame::VoidPtr #jobject ( *PopLocalFrame) (JNIEnv *env, jobject result);

    NewGlobalRef::VoidPtr #jobject ( *NewGlobalRef) (JNIEnv *env, jobject lobj);
    DeleteGlobalRef::VoidPtr #void ( *DeleteGlobalRef) (JNIEnv *env, jobject gref);
    DeleteLocalRef::VoidPtr #void ( *DeleteLocalRef) (JNIEnv *env, jobject obj);
    IsSameObject::VoidPtr #jboolean ( *IsSameObject) (JNIEnv *env, jobject obj1, jobject obj2);
    NewLocalRef::VoidPtr #jobject ( *NewLocalRef) (JNIEnv *env, jobject ref);
    EnsureLocalCapacity::VoidPtr #jint ( *EnsureLocalCapacity) (JNIEnv *env, jint capacity);

    AllocObject::VoidPtr #jobject ( *AllocObject) (JNIEnv *env, jclass clazz);
    NewObject::VoidPtr #jobject ( *NewObject) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    NewObjectV::VoidPtr #jobject ( *NewObjectV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    NewObjectA::VoidPtr #jobject ( *NewObjectA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    GetObjectClass::VoidPtr #jclass ( *GetObjectClass) (JNIEnv *env, jobject obj);
    IsInstanceOf::VoidPtr #jboolean ( *IsInstanceOf) (JNIEnv *env, jobject obj, jclass clazz);

    GetMethodID::VoidPtr #jmethodID ( *GetMethodID) (JNIEnv *env, jclass clazz, const char *name, const char *sig);

    CallObjectMethod::VoidPtr #jobject ( *CallObjectMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallObjectMethodV::VoidPtr #jobject ( *CallObjectMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallObjectMethodA::VoidPtr #jobject ( *CallObjectMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

    CallBooleanMethod::VoidPtr #jboolean ( *CallBooleanMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallBooleanMethodV::VoidPtr #jboolean ( *CallBooleanMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallBooleanMethodA::VoidPtr #jboolean ( *CallBooleanMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

    CallByteMethod::VoidPtr #jbyte ( *CallByteMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallByteMethodV::VoidPtr #jbyte ( *CallByteMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallByteMethodA::VoidPtr #jbyte ( *CallByteMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallCharMethod::VoidPtr #jchar ( *CallCharMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallCharMethodV::VoidPtr #jchar ( *CallCharMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallCharMethodA::VoidPtr #jchar ( *CallCharMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallShortMethod::VoidPtr #jshort ( *CallShortMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallShortMethodV::VoidPtr #jshort ( *CallShortMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallShortMethodA::VoidPtr #jshort ( *CallShortMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallIntMethod::VoidPtr #jint ( *CallIntMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallIntMethodV::VoidPtr #jint ( *CallIntMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallIntMethodA::VoidPtr #jint ( *CallIntMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallLongMethod::VoidPtr #jlong ( *CallLongMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallLongMethodV::VoidPtr #jlong ( *CallLongMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallLongMethodA::VoidPtr #jlong ( *CallLongMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallFloatMethod::VoidPtr #jfloat ( *CallFloatMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallFloatMEthodV::VoidPtr #jfloat ( *CallFloatMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallFloatMethodA::VoidPtr #jfloat ( *CallFloatMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallDoubleMethod::VoidPtr #jdouble ( *CallDoubleMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallDoubleMethodV::VoidPtr #jdouble ( *CallDoubleMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallDoubleMethodA::VoidPtr #jdouble ( *CallDoubleMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    CallVoidMethod::VoidPtr #void ( *CallVoidMethod) (JNIEnv *env, jobject obj, jmethodID methodID, ...);
    CallVoidMethodV::VoidPtr #void ( *CallVoidMethodV) (JNIEnv *env, jobject obj, jmethodID methodID, va_list args);
    CallVoidMethodA::VoidPtr #void ( *CallVoidMethodA) (JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

    CallNonvirtualObjectMethod::VoidPtr #jobject ( *CallNonvirtualObjectMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualObjectMethodV::VoidPtr #jobject ( *CallNonvirtualObjectMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualObjectMEthodA::VoidPtr #jobject ( *CallNonvirtualObjectMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

    CallNonvirtualBooleanMethod::VoidPtr #jboolean ( *CallNonvirtualBooleanMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualBooleanMethodV::VoidPtr #jboolean ( *CallNonvirtualBooleanMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualBooleanMethodA::VoidPtr #jboolean ( *CallNonvirtualBooleanMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

    CallNonvirtualByteMethod::VoidPtr #jbyte ( *CallNonvirtualByteMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualByteMethodV::VoidPtr #jbyte ( *CallNonvirtualByteMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualByteMethodA::VoidPtr #jbyte ( *CallNonvirtualByteMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonvirtualCharMethod::VoidPtr #jchar ( *CallNonvirtualCharMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualCharMethodV::VoidPtr #jchar ( *CallNonvirtualCharMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualCharMethodA::VoidPtr #jchar ( *CallNonvirtualCharMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonvirtualShortMethod::VoidPtr #jshort ( *CallNonvirtualShortMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualShortMethodV::VoidPtr #jshort ( *CallNonvirtualShortMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualShortMethodA::VoidPtr #jshort ( *CallNonvirtualShortMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonvirtualIntMethod::VoidPtr #jint ( *CallNonvirtualIntMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualIntMethodV::VoidPtr #jint ( *CallNonvirtualIntMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualIntMethodA::VoidPtr #jint ( *CallNonvirtualIntMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonvirtualLongMethod::VoidPtr #jlong ( *CallNonvirtualLongMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonVirtualLongMethodV::VoidPtr #jlong ( *CallNonvirtualLongMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualLongMethodA::VoidPtr #jlong ( *CallNonvirtualLongMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonVirtualFloatMethod::VoidPtr #jfloat ( *CallNonvirtualFloatMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualFloatMethodV::VoidPtr #jfloat ( *CallNonvirtualFloatMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualFloatMethodA::VoidPtr #jfloat ( *CallNonvirtualFloatMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    CallNonvirtualDoubleMethod::VoidPtr # jdouble ( *CallNonvirtualDoubleMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualDoubleMethodV::VoidPtr # jdouble ( *CallNonvirtualDoubleMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualDoubleMethodA::VoidPtr # jdouble ( *CallNonvirtualDoubleMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID,  const jvalue *args);

    CallNonvirtualVoidMethod::VoidPtr # void ( *CallNonvirtualVoidMethod) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);
    CallNonvirtualVoidMethodV::VoidPtr # void ( *CallNonvirtualVoidMethodV) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    CallNonvirtualVoidMethodA::VoidPtr # void ( *CallNonvirtualVoidMethodA) (JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

    GetFieldID::VoidPtr # jfieldID ( *GetFieldID) (JNIEnv *env, jclass clazz, const char *name, const char *sig);

    GetObjectField::VoidPtr # jobject ( *GetObjectField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetBooleanField::VoidPtr # jboolean ( *GetBooleanField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetByteField::VoidPtr # jbyte ( *GetByteField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetCharField::VoidPtr # jchar ( *GetCharField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetShortField::VoidPtr # jshort ( *GetShortField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetIntField::VoidPtr # jint ( *GetIntField)  (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetLongField::VoidPtr # jlong ( *GetLongField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetFloatField::VoidPtr # jfloat ( *GetFloatField) (JNIEnv *env, jobject obj, jfieldID fieldID);
    GetDoubleField::VoidPtr # jdouble ( *GetDoubleField) (JNIEnv *env, jobject obj, jfieldID fieldID);

    SetObjectField::VoidPtr # void ( *SetObjectField) (JNIEnv *env, jobject obj, jfieldID fieldID, jobject val);
    SetBooleanField::VoidPtr # void ( *SetBooleanField) (JNIEnv *env, jobject obj, jfieldID fieldID, jboolean val);
    SetByteField::VoidPtr # void ( *SetByteField)  (JNIEnv *env, jobject obj, jfieldID fieldID, jbyte val);
    SetCharField::VoidPtr # void ( *SetCharField) (JNIEnv *env, jobject obj, jfieldID fieldID, jchar val);
    SetShortField::VoidPtr # void ( *SetShortField) (JNIEnv *env, jobject obj, jfieldID fieldID, jshort val);
    SetIntField::VoidPtr # void ( *SetIntField) (JNIEnv *env, jobject obj, jfieldID fieldID, jint val);
    SetLongField::VoidPtr # void ( *SetLongField) (JNIEnv *env, jobject obj, jfieldID fieldID, jlong val);
    SetFloatField::VoidPtr # void ( *SetFloatField) (JNIEnv *env, jobject obj, jfieldID fieldID, jfloat val);
    SetDoubleField::VoidPtr # void ( *SetDoubleField) (JNIEnv *env, jobject obj, jfieldID fieldID, jdouble val);

    GetStaticMethodID::VoidPtr # jmethodID ( *GetStaticMethodID) (JNIEnv *env, jclass clazz, const char *name, const char *sig);

    CallStaticObjectMethod::VoidPtr # jobject ( *CallStaticObjectMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticObjectMethodV::VoidPtr #jobject ( *CallStaticObjectMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticObjectMethodA::VoidPtr # jobject ( *CallStaticObjectMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticBooleanMethod::VoidPtr # jboolean ( *CallStaticBooleanMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticBooleanMethodV::VoidPtr # jboolean ( *CallStaticBooleanMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticBooleanMethodA::VoidPtr # jboolean ( *CallStaticBooleanMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticByteMethod::VoidPtr #jbyte ( *CallStaticByteMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticByteMethodV::VoidPtr # jbyte ( *CallStaticByteMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticByteMethodA::VoidPtr #jbyte ( *CallStaticByteMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticCharMethod::VoidPtr # jchar ( *CallStaticCharMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticCharMethodV::VoidPtr # jchar ( *CallStaticCharMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticCharMethodA::VoidPtr # jchar ( *CallStaticCharMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticShortMethod::VoidPtr # jshort ( *CallStaticShortMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticShortMethodV::VoidPtr # jshort ( *CallStaticShortMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticShortMethodA::VoidPtr # jshort ( *CallStaticShortMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticIntMethod::VoidPtr #jint ( *CallStaticIntMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticIntMethodV::VoidPtr # jint ( *CallStaticIntMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticIntMethodA::VoidPtr # jint ( *CallStaticIntMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticLongMethod::VoidPtr # jlong ( *CallStaticLongMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticLongMethodV::VoidPtr # jlong ( *CallStaticLongMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticLongMethodA::VoidPtr # jlong ( *CallStaticLongMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticFloatMethod::VoidPtr # jfloat ( *CallStaticFloatMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticFloatMethodV::VoidPtr # jfloat ( *CallStaticFloatMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticFloatMethodA::VoidPtr # jfloat ( *CallStaticFloatMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticDoubleMethod::VoidPtr # jdouble ( *CallStaticDoubleMethod) (JNIEnv *env, jclass clazz, jmethodID methodID, ...);
    CallStaticDoubleMethodV::VoidPtr # jdouble ( *CallStaticDoubleMethodV) (JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    CallStaticDoubleMethodA::VoidPtr # jdouble ( *CallStaticDoubleMethodA) (JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    CallStaticVoidMethod::VoidPtr # void ( *CallStaticVoidMethod) (JNIEnv *env, jclass cls, jmethodID methodID, ...);
    CallStaticVoidMethodV::VoidPtr # void ( *CallStaticVoidMethodV) (JNIEnv *env, jclass cls, jmethodID methodID, va_list args);
    CallStaticVoidMethodA::VoidPtr # void ( *CallStaticVoidMethodA) (JNIEnv *env, jclass cls, jmethodID methodID, const jvalue * args);

    GetStaticFieldID::VoidPtr # jfieldID ( *GetStaticFieldID) (JNIEnv *env, jclass clazz, const char *name, const char *sig);
    GetStaticObjectField::VoidPtr # jobject ( *GetStaticObjectField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticBooleanField::VoidPtr # jboolean ( *GetStaticBooleanField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticByteField::VoidPtr # jbyte ( *GetStaticByteField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticCharField::VoidPtr # jchar ( *GetStaticCharField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticShortField::VoidPtr # jshort ( *GetStaticShortField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticIntField::VoidPtr # jint ( *GetStaticIntField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticLongField::VoidPtr # jlong ( *GetStaticLongField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticFloatField::VoidPtr # jfloat ( *GetStaticFloatField) (JNIEnv *env, jclass clazz, jfieldID fieldID);
    GetStaticDoubleField::VoidPtr # jdouble ( *GetStaticDoubleField) (JNIEnv *env, jclass clazz, jfieldID fieldID);

    SetStaticObjectField::VoidPtr # void ( *SetStaticObjectField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jobject value);
    SetStaticBooleanField::VoidPtr # void ( *SetStaticBooleanField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jboolean value);
    SetStaticByteField::VoidPtr # void ( *SetStaticByteField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jbyte value);
    SetStaticCharField::VoidPtr # void ( *SetStaticCharField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jchar value);
    SetStaticShortField::VoidPtr # void ( *SetStaticShortField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jshort value);
    SetStaticIntField::VoidPtr # void ( *SetStaticIntField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jint value);
    SetStaticLongField::VoidPtr # void ( *SetStaticLongField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jlong value);
    SetStaticFloatField::VoidPtr # void ( *SetStaticFloatField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jfloat value);
    SetStaticDoubleField::VoidPtr # void ( *SetStaticDoubleField) (JNIEnv *env, jclass clazz, jfieldID fieldID, jdouble value);

    NewString::VoidPtr #::VoidPtr # jstring ( *NewString) (JNIEnv *env, const jchar *unicode, jsize len);
    GetStringLength::VoidPtr # jsize ( *GetStringLength) (JNIEnv *env, jstring str);
    GetStringChars::VoidPtr # const jchar *( *GetStringChars) (JNIEnv *env, jstring str, jboolean *isCopy);
    ReleaseStringChars::VoidPtr # void ( *ReleaseStringChars) (JNIEnv *env, jstring str, const jchar *chars);

    NewStringUTF::VoidPtr # jstring ( *NewStringUTF) (JNIEnv *env, const char *utf);
    GetStringUTFLength::VoidPtr # jsize ( *GetStringUTFLength) (JNIEnv *env, jstring str);
    GetStringUTFChars::VoidPtr # const char* ( *GetStringUTFChars) (JNIEnv *env, jstring str, jboolean *isCopy);
    ReleaseStringUTFChars::VoidPtr # void ( *ReleaseStringUTFChars) (JNIEnv *env, jstring str, const char* chars);


    GetArrayLength::VoidPtr # jsize ( *GetArrayLength ) (JNIEnv *env, jarray array);

    NewObjectArray::VoidPtr # jobjectArray ( *NewObjectArray) (JNIEnv *env, jsize len, jclass clazz, jobject init);
    GetObjectArrayElement::VoidPtr # jobject ( *GetObjectArrayElement) (JNIEnv *env, jobjectArray array, jsize index);
    SetObjectArrayElement::VoidPtr # void ( *SetObjectArrayElement) (JNIEnv *env, jobjectArray array, jsize index, jobject val);

    NewBooleanArray::VoidPtr # jbooleanArray ( *NewBooleanArray) (JNIEnv *env, jsize len);
    NewByteArray::VoidPtr # jbyteArray ( *NewByteArray) (JNIEnv *env, jsize len);
    NewCharArray::VoidPtr # jcharArray ( *NewCharArray) (JNIEnv *env, jsize len);
    NewShortArray::VoidPtr # jshortArray ( *NewShortArray) (JNIEnv *env, jsize len);
    NewIntArray::VoidPtr # jintArray ( *NewIntArray) (JNIEnv *env, jsize len);
    NewLongArray::VoidPtr # jlongArray ( *NewLongArray) (JNIEnv *env, jsize len);
    NewFloatArray::VoidPtr # jfloatArray ( *NewFloatArray) (JNIEnv *env, jsize len);
    NewDoubleArray::VoidPtr # jdoubleArray ( *NewDoubleArray) (JNIEnv *env, jsize len);

    GetBooleanArrayElements::VoidPtr # jboolean * ( *GetBooleanArrayElements) (JNIEnv *env, jbooleanArray array, jboolean *isCopy);
    GetByteArrayElements::VoidPtr # jbyte * ( *GetByteArrayElements) (JNIEnv *env, jbyteArray array, jboolean *isCopy);
    GetCharArrayElements::VoidPtr # jchar * ( *GetCharArrayElements) (JNIEnv *env, jcharArray array, jboolean *isCopy);
    GetShortArrayElements::VoidPtr # jshort * ( *GetShortArrayElements) (JNIEnv *env, jshortArray array, jboolean *isCopy);
    GetIntArrayElements::VoidPtr # jint * ( *GetIntArrayElements) (JNIEnv *env, jintArray array, jboolean *isCopy);
    GetLongArrayElements::VoidPtr # jlong * ( *GetLongArrayElements ) (JNIEnv *env, jlongArray array, jboolean *isCopy);
    GetFloatArrayElements::VoidPtr # jfloat * ( *GetFloatArrayElements) (JNIEnv *env, jfloatArray array, jboolean *isCopy);
    GetDoubleArrayElements::VoidPtr # jdouble * ( *GetDoubleArrayElements) (JNIEnv *env, jdoubleArray array, jboolean *isCopy);

    ReleaseBooleanArrayElements::VoidPtr # void ( *ReleaseBooleanArrayElements ) (JNIEnv *env, jbooleanArray array, jboolean *elems, jint mode);
    ReleaseByteArrayElements::VoidPtr # void ( *ReleaseByteArrayElements ) (JNIEnv *env, jbyteArray array, jbyte *elems, jint mode);
    ReleaseCharArrayElements::VoidPtr # void ( *ReleaseCharArrayElements ) (JNIEnv *env, jcharArray array, jchar *elems, jint mode);
    ReleaseShortArrayElements::VoidPtr # void ( *ReleaseShortArrayElements) (JNIEnv *env, jshortArray array, jshort *elems, jint mode);
    ReleaseIntArrayElements::VoidPtr # void ( *ReleaseIntArrayElements) (JNIEnv *env, jintArray array, jint *elems, jint mode);
    ReleaseLongArrayElements::VoidPtr # void ( *ReleaseLongArrayElements ) (JNIEnv *env, jlongArray array, jlong *elems, jint mode);
    ReleaseFloatArrayElements::VoidPtr # void ( *ReleaseFloatArrayElements) (JNIEnv *env, jfloatArray array, jfloat *elems, jint mode);
    ReleaseDoubleArrayElements::VoidPtr # void ( *ReleaseDoubleArrayElements ) (JNIEnv *env, jdoubleArray array, jdouble *elems, jint mode);

    GetBooleanArrayRegion::VoidPtr # void ( *GetBooleanArrayRegion ) (JNIEnv *env, jbooleanArray array, jsize start, jsize l, jboolean *buf);
    GetByteArrayRegion::VoidPtr # void ( *GetByteArrayRegion) (JNIEnv *env, jbyteArray array, jsize start, jsize len, jbyte *buf);
    vGetCharArrayRegion::VoidPtr # void ( *GetCharArrayRegion) (JNIEnv *env, jcharArray array, jsize start, jsize len, jchar *buf);
    GetShortArrayRegion::VoidPtr # void ( *GetShortArrayRegion ) (JNIEnv *env, jshortArray array, jsize start, jsize len, jshort *buf);
    GetIntArrayRegion::VoidPtr # void ( *GetIntArrayRegion ) (JNIEnv *env, jintArray array, jsize start, jsize len, jint *buf);
    GetLongArrayRegion::VoidPtr # void ( *GetLongArrayRegion) (JNIEnv *env, jlongArray array, jsize start, jsize len, jlong *buf);
    GetFloatArrayRegion::VoidPtr # void ( *GetFloatArrayRegion) (JNIEnv *env, jfloatArray array, jsize start, jsize len, jfloat *buf);
    GetDoubleArrayRegion::VoidPtr # void ( *GetDoubleArrayRegion) (JNIEnv *env, jdoubleArray array, jsize start, jsize len, jdouble *buf);

    SetBooleanArrayRegion::VoidPtr # void ( *SetBooleanArrayRegion )(JNIEnv *env, jbooleanArray array, jsize start, jsize l, const jboolean *buf);
    SetByteArrayRegion::VoidPtr # void ( *SetByteArrayRegion) (JNIEnv *env, jbyteArray array, jsize start, jsize len, const jbyte *buf);
    SetCharArrayRegion::VoidPtr # void ( *SetCharArrayRegion) (JNIEnv *env, jcharArray array, jsize start, jsize len, const jchar *buf);
    SetShortArrayRegion::VoidPtr # void ( *SetShortArrayRegion ) (JNIEnv *env, jshortArray array, jsize start, jsize len, const jshort *buf);
    SetIntArrayRegion::VoidPtr # void ( *SetIntArrayRegion) (JNIEnv *env, jintArray array, jsize start, jsize len, const jint *buf);
    SetLongArrayRegion::VoidPtr # void ( *SetLongArrayRegion) (JNIEnv *env, jlongArray array, jsize start, jsize len, const jlong *buf);
    SetFloatArrayRegion::VoidPtr # void ( *SetFloatArrayRegion ) (JNIEnv *env, jfloatArray array, jsize start, jsize len, const jfloat *buf);
    SetDoubleArrayRegion::VoidPtr # void ( *SetDoubleArrayRegion) (JNIEnv *env, jdoubleArray array, jsize start, jsize len, const jdouble *buf);

    RegisterNatives::VoidPtr # jint ( *RegisterNatives) (JNIEnv *env, jclass clazz, const JNINativeMethod *methods, jint nMethods);
    UnregisterNatives::VoidPtr # jint ( *UnregisterNatives ) (JNIEnv *env, jclass clazz);

    MonitorEnter::VoidPtr # jint ( *MonitorEnter) (JNIEnv *env, jobject obj);
    MonitorExit::VoidPtr # jint ( *MonitorExit ) (JNIEnv *env, jobject obj);

    GetJavaVM::VoidPtr # jint ( *GetJavaVM) (JNIEnv *env, JavaVM **vm);

    GetStringRegion::VoidPtr # void ( *GetStringRegion ) (JNIEnv *env, jstring str, jsize start, jsize len, jchar *buf);
    GetStringUTFRegion::VoidPtr # void ( *GetStringUTFRegion) (JNIEnv *env, jstring str, jsize start, jsize len, char *buf);

    GetPrimitiveArrayCritical::VoidPtr # void * ( *GetPrimitiveArrayCritical) (JNIEnv *env, jarray array, jboolean *isCopy);
    ReleasePrimitiveArrayCritical::VoidPtr # void ( *ReleasePrimitiveArrayCritical ) (JNIEnv *env, jarray array, void *carray, jint mode);

    GetStringCritical::VoidPtr # const jchar * ( *GetStringCritical ) (JNIEnv *env, jstring string, jboolean *isCopy);
    ReleaseStringCritical::VoidPtr # void ( *ReleaseStringCritical ) (JNIEnv *env, jstring string, const jchar *cstring);

    NewWeakGlobalRef::VoidPtr # jweak ( *NewWeakGlobalRef) (JNIEnv *env, jobject obj);
    DeleteWeakGlobalRef::VoidPtr # void ( *DeleteWeakGlobalRef) (JNIEnv *env, jweak ref);

    ExceptionCheck::VoidPtr # jboolean ( *ExceptionCheck) (JNIEnv *env);

    NewDirectByteBuffer::VoidPtr # jobject ( *NewDirectByteBuffer ) (JNIEnv* env, void* address, jlong capacity);
    GetDirectBufferAddress::VoidPtr # void* ( *GetDirectBufferAddress ) (JNIEnv* env, jobject buf);
    GetDirectBufferCapacity::VoidPtr # jlong ( *GetDirectBufferCapacity) (JNIEnv* env, jobject buf);

    #/* New JNI 1.6 Features */

    GetObjectRefType::VoidPtr # jobjectRefType ( *GetObjectRefType) (JNIEnv* env, jobject obj);
end #};

struct JNIEnv
    JNINativeInterface_::Ptr{JNINativeInterface}
end

const JNIEnvPtr = Ptr{JNIEnv}

struct JNIInvokeInterface #struct JNIInvokeInterface_ {
    reserved0::VoidPtr #void *reserved0;
    reserved1::VoidPtr #void *reserved1;
    reserved2::VoidPtr #void *reserved2;

    DestroyJavaVM::VoidPtr #jint (JNICALL *DestroyJavaVM)(JavaVM *vm);

    AttachCurrentThread::VoidPtr #jint (JNICALL *AttachCurrentThread)(JavaVM *vm, void **penv, void *args);

    DetachCurrentThread::VoidPtr #jint (JNICALL *DetachCurrentThread)(JavaVM *vm);

    GetEnv::VoidPtr #jint (JNICALL *GetEnv)(JavaVM *vm, void **penv, jint version);

    AttachCurrentThreadAsDaemon::VoidPtr #jint (JNICALL *AttachCurrentThreadAsDaemon)(JavaVM *vm, void **penv, void *args);
end

struct JavaVM
    JNIInvokeInterface_::Ptr{JNIInvokeInterface}
end

struct JavaCallError <: Exception
    msg::String
end
