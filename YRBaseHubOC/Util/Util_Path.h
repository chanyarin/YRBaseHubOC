//
//  Util_Path.h
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util_Path : NSObject

/** - Path_Home:获取沙盒主目录路径 */
NSString *Path_Home(void);

/** - Path_Documents:获取Documents目录路径 */
NSString *Path_Documents(void);

/** - Path_Library:获取Library目录路径 */
NSString *Path_Library(void);

/** - Path_Cache:获取Cache目录路径 */
NSString *Path_Cache(void);

/** - Path_Temp:获取tmp目录路径 */
NSString *Path_Temp(void);

/** - Path_Bundle:获取应用程序包目录路径 */
NSString *Path_Bundle(void);

/** - Path_BundleSource:获取应用程序包内资源目录路径 */
NSString *Path_BundleSource(NSString *name, NSString *type);

@end
