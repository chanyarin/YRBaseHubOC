//
//  Macro_Block.h
//  YRProduct
//
//  Created by hwkj on 2018/2/9.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#ifndef Macro_Block_h
#define Macro_Block_h

/* 第一种定义方式：使用如下
   @weakify(self)
   [self doSomething^{
      @strongify(self)
      if (!self) return;
      ...
   }]; */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

/* 第二种定义方式：使用如下
 WeakSelf(self)
 [self doSomething^{
    StrongSelf(self)
    if (!strongself) return;
    ...
 }];
 注：使用起来相对麻烦，复制粘贴代码需要改动很多地方 */
#define WeakSelf(type) __weak typeof(type) weak##type = type
#define StrongSelf(type) __strong typeof(type) strong##type = type


#endif /* Macro_Block_h */
