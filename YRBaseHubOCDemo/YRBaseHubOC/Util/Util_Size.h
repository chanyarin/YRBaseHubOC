//
//  Util_Size.h
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util_Size : NSObject

/** - Screen_height:屏幕高度 */
CGFloat Screen_Height(void);

/** - Screen_width:屏幕宽度 */
CGFloat Screen_Width(void);

/** - Screen_bounds:屏幕尺寸 */
CGRect Screen_Bounds(void);

/** - Screen_bounds:屏幕分辨率 */
CGFloat Screen_Resolution(void);

@end
