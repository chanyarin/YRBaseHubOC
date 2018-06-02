//
//  YRNetworkEnum.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/2.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#ifndef YRNetworkEnum_h
#define YRNetworkEnum_h

/** 请求方式 */
typedef NS_ENUM(NSUInteger, YRRequestMethod) {
    YRRequestMethodGET,     // GET请求
    YRRequestMethodPOST,    // POST请求
    YRRequestMethodPUT,     // PUT请求
    YRRequestMethodDELETE,  // DELETE请求
    YRRequestMethodPATCH,   // PATCH请求
    YRRequestMethodHEAD     // HEAD请求
};

/** 请求序列化方式 */
typedef NS_ENUM(NSUInteger, YRRequestSerializer) {
    YRRequestSerializerHTTP,
    YRRequestSerializerJSON
};

/** 响应序列化方式 */
typedef NS_ENUM(NSUInteger, YRResponseSerializer) {
    YRResponseSerializerHTTP,       // Data类型，解析数据为二进制格式
    YRResponseSerializerJSON,       // JSON类型，解析数据为JSON格式
    YRResponseSerializerXML,        // XML类型，解析数据为XML格式
    YRResponseSerializerPLIST,      // Plist类型，解析数据为Plist格式
    YRResponseSerializerCOMPOUND,   // Compound类型，解析数据为Compound格式
    YRResponseSerializerIMAGE       // Image类型，解析数据为Image格式
};

#endif /* YRNetworkEnum_h */
