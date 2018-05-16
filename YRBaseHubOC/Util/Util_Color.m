//
//  Util_Color.m
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "Util_Color.h"

@implementation Util_Color

/** - Color_Clear:清空颜色 */
UIColor *Color_Clear() {
    return [UIColor clearColor];
}

/** - Color_RGB:根据相同rgb值配置颜色 alpha = 1 */
UIColor *Color_SRGB(CGFloat s) {
    return [UIColor colorWithRed:(s)/255.0
                           green:(s)/255.0
                            blue:(s)/255.0
                           alpha:1.0];
}

/** - Color_RGB:根据相同rgb值配置颜色 alpha != 1 */
UIColor *Color_SRGBA(CGFloat s, CGFloat a) {
    return [UIColor colorWithRed:(s)/255.0
                           green:(s)/255.0
                            blue:(s)/255.0
                           alpha:a];
}

/** - Color_RGB:根据不同rgb值配置颜色 alpha = 1 */
UIColor *Color_RGB(CGFloat r,CGFloat g, CGFloat b) {
    return [UIColor colorWithRed:(r)/255.0
                           green:(g)/255.0
                            blue:(b)/255.0
                           alpha:1.0];
}

/** - Color_RGBA:根据不同rgb值配置颜色 alpha != 1 */
UIColor *Color_RGBA(CGFloat r,CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:(r)/255.0
                           green:(g)/255.0
                            blue:(b)/255.0
                           alpha:a];
}

/** - Color_Hex:根据Hex码配置颜色(十六进制码 - 如：0x000000) */
UIColor *Color_Hex(int hexValue) {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:1.0];
}

@end
