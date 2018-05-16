//
//  UIViewController+Stack.h
//  YRProduct
//
//  Created by hwkj on 2018/2/9.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Stack)

/** 返回指定控制器
 @param controllerClass 控制器类
 */
- (void)backToSpecifyController:(Class)controllerClass;

/** 删除指定控制器
 @param controllerClass 控制器类
 */
- (void)deleteSpecifyController:(Class)controllerClass;

@end
