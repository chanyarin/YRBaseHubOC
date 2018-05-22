//
//  UIViewController+Alert.h
//  YRProduct
//
//  Created by hwkj on 2018/2/11.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRAlertController;

/** 配置action标题 */
typedef YRAlertController * (^YRAlertAction)(NSString *title);

/** 配置action对象的事件回调 */
typedef void(^YRAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, YRAlertController *alert);

/** Alert弹出后的事件回调 */
typedef void(^AlertDidAppear)(void);

/** Alert消失后的事件回调 */
typedef void(^AlertDidDisappear)(void);

/** 此处真正实现Action与相应回调Block绑定在一起 */
typedef void(^YRAlertActionConfig)(YRAlertActionBlock);


/**
 封装AlertController，iOS8以上使用
 */
@interface YRAlertController : UIAlertController

/** Alert是否执行弹出动画，默认YES */
@property (nonatomic, assign) BOOL isAnimated;

/** Alert作为Toast的显示时间 */
@property (nonatomic, assign) NSTimeInterval toastDuration;

/** Alert弹出后的事件回调 */
@property (nonatomic, copy) AlertDidAppear alertDidAppear;

/** Alert消失后的事件回调 */
@property (nonatomic, copy) AlertDidDisappear alertDidDisappear;

/** 此处真正实现Action与相应回调Block绑定在一起 */
- (YRAlertActionConfig)alertActionConfig;

/** Alert添加默认样式按钮 */
- (YRAlertAction)addDefaultAction;

/** Alert添加取消样式按钮 */
- (YRAlertAction)addCancelAction;

/** Alert添加警告样式按钮 */
- (YRAlertAction)addDestructiveAction;

/** Alert实例化入口 */
- (instancetype)initAlertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(UIAlertControllerStyle)style;


@end

typedef void(^YRAlertMaker)(YRAlertController *alert);

@interface UIViewController (Alert)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                     maker:(YRAlertMaker)maker
               actionBlock:(YRAlertActionBlock)actionBlock;

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                           maker:(YRAlertMaker)maker
                     actionBlock:(YRAlertActionBlock)actionBlock;

@end
