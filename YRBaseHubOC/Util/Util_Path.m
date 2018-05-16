//
//  Util_Path.m
//  YRProduct
//
//  Created by hwkj on 2018/2/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "Util_Path.h"

@implementation Util_Path

/** NSArray<NSString *> *NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
 * directory   : 搜索的目录名称
 * domainMask  : 指定搜索范围，这里的NSUserDomainMask表示搜索的范围限制于当前应用的沙盒目录
 * expandTilde : 表示是否展开波浪线。全写形式是/User/userName，该值为YES即表示写成全写形式，为NO就表示直接写成“~”
 */

/** - Path_Home:应用程序目录的路径 */
NSString *Path_Home(void) {
    return NSHomeDirectory();
}

/** - Path_Documents:获取Documents目录路径 */
NSString *Path_Documents(void) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

/** - Path_Library:获取Library目录路径 */
NSString *Path_Library(void) {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

/** - Path_Cache:获取Cache目录路径 */
NSString *Path_Cache(void) {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

/** - Path_Temp:获取tmp目录路径 */
NSString *Path_Temp(void) {
    return NSTemporaryDirectory();
}

/** - Path_Bundle:获取应用程序包目录路径 */
NSString *Path_Bundle(void) {
    return [[NSBundle mainBundle] bundlePath];
}

/** - Path_BundleSource:获取应用程序包内资源目录路径 */
NSString *Path_BundleSource(NSString *name, NSString *type) {
    return [[NSBundle mainBundle] pathForResource:name ofType:type];
}

@end
