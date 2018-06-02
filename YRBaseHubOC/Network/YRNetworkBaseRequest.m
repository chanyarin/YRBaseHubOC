//
//  YRNetworkBaseRequest.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/1.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "YRNetworkBaseRequest.h"
#import "YRNetworkManager.h"
#import <YYModel/YYModel.h>
#import <sys/utsname.h>

@interface YRNetworkBaseRequest ()

@property (nonatomic, copy) YRRequestSuccessBlock successBlock;
@property (nonatomic, copy) YRRequestFailureBlock failureBlock;

@end

@implementation YRNetworkBaseRequest

- (NSString *)requestURLDomain {
    return @"http://219.129.166.102:10010";
}

- (NSString *)requestURLPath {
    NSAssert([self isMemberOfClass:[YRNetworkBaseRequest class]], @"子类必须实现requestURLPath");
    return nil;
}

- (YRRequestMethod)requestMethod {
    return YRRequestMethodGET;
}

- (YRRequestSerializer)requestSerializer {
    return YRRequestSerializerHTTP;
}

- (YRResponseSerializer)responseSerializer {
    return YRResponseSerializerJSON;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    return nil;
}

- (void)requestWithSuccess:(YRRequestSuccessBlock)successBlock failure:(YRRequestFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    //拼接完整的请求路径
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self requestURLDomain],[self requestURLPath]];
    
    [[YRNetworkManager shareManager] requestWithHTTPMethod:[self requestMethod]
                                                 urlString:urlString
                                                parameters:[self parameters]
                                         requestSerializer:[self requestSerializer]
                                        responseSerializer:[self responseSerializer]
                                         completionHandler:^(BOOL success, id  _Nonnull response) {
                                             if (success) {
                                                 successBlock(200, @{}, nil);
                                             } else {
                                                 failureBlock(nil);
                                             }
                                         }];
}

- (NSDictionary *)parameters {
    //子类可将请求参数作为属性进行Model转型
    NSDictionary *json = self.yy_modelToJSONObject;
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *params = [(NSDictionary *)json mutableCopy];
        for (id key in params.allKeys) {
            id obj = [params objectForKey:key];
            if (!obj || [obj isKindOfClass:[NSNull class]] || obj == (id)kCFNull) {
                [params removeObjectForKey:key];
            }
        }
        return @{@"head":[self paramHead:@"XXGK008"],
                 @"body":params};
    }
    return @{};
}

- (NSDictionary *)paramHead:(NSString *)action {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //APP版本号
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *versionString = [NSString stringWithFormat:@"%@.%@",appVersion,buildVersion];
    
    //通用唯一标识符(Universally Unique Identifie)
    NSString *uuidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUIDSTR"];
    uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //流水号
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval=[date timeIntervalSince1970] * 10000000000;
    NSInteger randomNumber = random() % 10;
    NSString *timeString = [NSString stringWithFormat:@"%f", interval+randomNumber];
    NSArray *timeArray = [timeString componentsSeparatedByString:@"."];
    NSString *tidString = [timeArray objectAtIndex:0];
    
    //设备系统版本号
    UIDevice *device=[[UIDevice alloc] init];
    NSString *osString = [NSString stringWithFormat:@"iOS_%@",device.systemVersion];
    
    //时间戳
    NSString *timeStamp = [self getTimeStamp:YES];
    
    //设备屏幕尺寸
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString *screenString = [NSString stringWithFormat:@"%f_%f", width, height];
    
    //设备型号
    NSString *platform = [self getDeviceVersion];
    
    NSDictionary *paramHead = @{@"tid":tidString,              //流水号
                                @"action":action,              //请求动作
                                @"timestamp":timeStamp,        //时间戳
                                @"ua":platform,                //设备型号
                                @"os":osString,                //设备系统版本
                                @"screen":screenString,        //设备屏幕尺寸
                                @"clientid":[NSString stringWithFormat:@"%@",uuidString],        //设备通用唯一标识符
                                @"softname":@"swrs",       //应用名
                                @"version":versionString,      //应用版本
                                @"channelid":@"test",    //发布渠道
                                @"longitude":@"",   //城市经度
                                @"latitude":@""};    //城市纬度
    
    return paramHead;
}

- (NSString *)getTimeStamp:(BOOL)flag {
    // 2014-03-08 21:26:47
    // 对字符串进行编码后转化车NSData对象
    NSInteger year,month,day,hour,min,sec,week;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    min = [comps minute];
    sec = [comps second];
    if (flag) {
        return [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec] ;
    } else {
        return [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%d%d%d%d",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec, arc4random() % 10,arc4random() % 10,arc4random() % 10,arc4random() % 10 ] ;
    }
}

- (NSString*)getDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

@end
