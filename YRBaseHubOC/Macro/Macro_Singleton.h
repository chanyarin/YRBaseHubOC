//
//  Macro_Singleton.h
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#ifndef Macro_Singleton_h
#define Macro_Singleton_h

#define single_interface(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define single_implementation(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}


#else
#define singleM static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
\
- (id)autorelease\
{\
return _instance;\
}\
-(instancetype)retain\
{\
return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
return MAXFLOAT;\
}
#endif

#endif /* Macro_Singleton_h */
