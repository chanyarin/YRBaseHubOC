//
//  Util_Size.m
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "Util_Size.h"

@implementation Util_Size

/** - Screen_height:屏幕高度 */
CGFloat Screen_Height(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

/** - Screen_width:屏幕宽度 */
CGFloat Screen_Width(void) {
    return [UIScreen mainScreen].bounds.size.width;
}

/** - C_Screen_bounds:屏幕尺寸 */
CGRect Screen_Bounds(void) {
    return [UIScreen mainScreen].bounds;
}

/** - Screen_bounds:屏幕分辨率 */
CGFloat Screen_Resolution(void) {
    return Screen_Width() * Screen_Height() * [UIScreen mainScreen].scale;
}

@end
