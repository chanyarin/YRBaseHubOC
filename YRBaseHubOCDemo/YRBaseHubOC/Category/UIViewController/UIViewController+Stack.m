//
//  UIViewController+Stack.m
//  YRProduct
//
//  Created by hwkj on 2018/2/9.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "UIViewController+Stack.h"

@implementation UIViewController (Stack)

- (void)backToSpecifyController:(Class)controllerClass {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:controllerClass]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

- (void)deleteSpecifyController:(Class)controllerClass {
    NSMutableArray *controllerArray = self.navigationController.viewControllers.mutableCopy;
    for (UIViewController *controller in controllerArray) {
        if ([controller isKindOfClass:controllerClass]) {
            [controllerArray removeObject:controller];
            break;
        }
    }
    [self.navigationController setViewControllers:controllerArray animated:NO];
}

@end
