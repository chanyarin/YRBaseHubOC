//
//  YRNetworkRequestCallback.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YRNetworkBaseRequest;

@protocol AFMultipartFormData;

typedef void(^AFConstructingBodyBlock)(id<AFMultipartFormData> data);
typedef void(^AFURLSessionTaskProgressBlock)(NSProgress *progress);


/*!
 *   AFN 请求封装的Block回调
 */
typedef void(^YRRequestSuccessBlock)(NSInteger errCode, NSDictionary *responseDict, id model);
typedef void(^YRRequestFailureBlock)(NSError *error);


/*!
 *   AFN 请求封装的代理回调
 */
@protocol YRNetworkBaseRequest <NSObject>

@optional
/**
 *   请求结束
 *   @param returnData 返回的数据
 */
- (void)requestDidFinishLoadingWithData:(id)returnData errCode:(NSInteger)errCode;

/**
 *   请求失败
 *   @param error 失败的 error
 */
- (void)requestDidFailWithError:(NSError *)error;

/**
 *   网络请求项即将被移除掉
 *   @param request 网络请求项
 */
- (void)requestWillDealloc:(YRNetworkBaseRequest *)request;
@end
