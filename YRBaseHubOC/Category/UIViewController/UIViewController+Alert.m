//
//  UIViewController+Alert.m
//  YRProduct
//
//  Created by hwkj on 2018/2/11.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "UIViewController+Alert.h"

static NSTimeInterval const ToastDefaultDuration = 1.0f;

@interface YRAlertActionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;

@end

@implementation YRAlertActionModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertViewStyleDefault;
    }
    return self;
}

@end

@interface YRAlertController ()

@property (nonatomic, strong) NSMutableArray <YRAlertActionModel *> *alertActionArray;

@end

@implementation YRAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isAnimated = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.alertDidDisappear) {
        self.alertDidDisappear();
    }
}

#pragma mark - public methods

- (YRAlertAction)addDefaultAction {
    return ^(NSString *title) {
        YRAlertActionModel *actionModel = [[YRAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (YRAlertAction)addCancelAction {
    return ^(NSString *title) {
        YRAlertActionModel *actionModel = [[YRAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (YRAlertAction)addDestructiveAction {
    return ^(NSString *title) {
        YRAlertActionModel *actionModel = [[YRAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

#pragma mark - private methods

- (YRAlertActionConfig)alertActionConfig {
    return ^(YRAlertActionBlock actionBlock) {
        if (self.alertActionArray.count > 0) {
            __weak typeof(self) weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(YRAlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                [self addAction:alertAction];
            }];
        } else {
            NSTimeInterval duration = self.toastDuration > 0 ?: ToastDefaultDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:self.isAnimated completion:nil];
            });
        }
    };
}

- (instancetype)initAlertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(UIAlertControllerStyle)style {
    if (!(title.length > 0) &&
        (message.length > 0) &&
        (style == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:style];
    if (!self) {
        return nil;
    }
    
    self.isAnimated = YES;
    self.toastDuration = ToastDefaultDuration;
    
    return self;
}

#pragma mark - getters and setters

- (NSMutableArray <YRAlertActionModel *> *)alertActionArray {
    if (!_alertActionArray) {
        _alertActionArray = [[NSMutableArray alloc] init];
    }
    return _alertActionArray;
}

@end

@implementation UIViewController (Alert)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                     maker:(YRAlertMaker)maker
               actionBlock:(YRAlertActionBlock)actionBlock {
    [self showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message maker:maker actionBlock:actionBlock];
}

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                           maker:(YRAlertMaker)maker
                     actionBlock:(YRAlertActionBlock)actionBlock {
    [self showAlertWithStyle:UIAlertControllerStyleActionSheet title:title message:message maker:maker actionBlock:actionBlock];
}

- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message maker:(YRAlertMaker)maker actionBlock:(YRAlertActionBlock)actionBlock {
    if (maker) {
        YRAlertController *alert = [[YRAlertController alloc] initAlertControllerWithTitle:title message:message style:style];
        if (!alert) {
            return;
        }
        maker(alert);
        alert.alertActionConfig(actionBlock);
        if (alert.alertDidAppear) {
            [self presentViewController:alert animated:alert.isAnimated completion:^{
                alert.alertDidAppear();
            }];
        } else {
            [self presentViewController:alert animated:alert.isAnimated completion:nil];
        }
    }
}

@end
