//
//  YRNetworkBaseRequest.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRNetworkRequestCallback.h"
#import "YRNetworkEnum.h"

@interface YRNetworkBaseRequest : NSObject

/**
 * @brief 请求URL域名
 *
 * @warning 按需重写
 */
- (NSString *)requestURLDomain;

/**
 * @brief 请求URL路径
 *
 * @warning 必须重写
 */
- (NSString *)requestURLPath;

/**
 * @brief 请求方式 GET or POST
 *
 * @warning 按需重写
 */
- (YRRequestMethod)requestMethod; ///< 默认 GET 请求

/**
 * @brief 请求序列类型
 *
 * @warning 按需重写
 */
- (YRRequestSerializer)requestSerializer;

/**
 * @brief 响应序列类型
 *
 * @warning 按需重写
 */
- (YRResponseSerializer)responseSerializer;

/**
 * @brief 设置请求头
 *
 * @warning 按需重写
 */
- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary; ///< Additional HTTP request header field. HTTP 请求头配置，按需重写

- (void)requestWithSuccess:(YRRequestSuccessBlock)success
                   failure:(YRRequestFailureBlock)failure;

@end
