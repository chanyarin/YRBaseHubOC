//
//  YRNetworkDownloadModel.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/30.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "YRNetworkDownloadModel.h"

@implementation YRNetworkProgressModel

@end

@implementation YRNetworkDownloadModel

- (instancetype)initWithResourceURLString:(NSString *)URLString {
    if (self = [super init]) {
        _resourceURLString = URLString;
        _fileName = [URLString lastPathComponent];
        _progressModel = [YRNetworkProgressModel new];
    }
    return self;
}

@end
