//
//  Util_Color.h
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util_Color : NSObject

/** - Color_Clear:清空颜色 */
UIColor *Color_Clear(void);

/** - Color_SRGB:根据相同rgb值配置颜色 alpha = 1 */
UIColor *Color_SRGB(CGFloat s);

/** - Color_SRGBA:根据相同rgb值配置颜色 alpha != 1 */
UIColor *Color_SRGBA(CGFloat s, CGFloat a);

/** - Color_RGB:根据不同rgb值配置颜色 alpha = 1 */
UIColor *Color_RGB(CGFloat r,CGFloat g, CGFloat b);

/** - Color_RGBA:根据不同rgb值配置颜色 alpha != 1 */
UIColor *Color_RGBA(CGFloat r,CGFloat g, CGFloat b, CGFloat a);

/** - Color_Hex:根据Hex码配置颜色(十六进制码 - 如：0x000000) */
UIColor *Color_Hex(int hexValue);

@end
