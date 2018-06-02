//
//  XXGKBannerRequest.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/2.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "XXGKBannerRequest.h"

@implementation XXGKBannerRequest

- (NSString *)requestURLPath {
    return @"/SWAPI/api/xxgk";
}

- (YRRequestMethod)requestMethod {
    return YRRequestMethodPOST;
}

- (YRRequestSerializer)requestSerializer {
    return YRRequestSerializerJSON;
}

- (YRResponseSerializer)responseSerializer {
    return YRResponseSerializerHTTP;
}

@end
