//
//  YRNetworkManager.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/30.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRNetworkDownloadModel.h"
#import "YRNetworkEnum.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(7_0) @interface YRNetworkManager : NSObject

/** 下载文件所在根目录。默认是 'yarin.network.manager' */
@property (nonatomic, copy, readonly) NSString *downloadDirectory;

/** 处于正在下载状态的model */
@property (nonatomic, strong, readonly) NSMutableArray <__kindof YRNetworkDownloadModel *> *downloadingModels;

/** 处于等待下载状态的model，设置 maxDownloadCount 且超过设置值时有效 */
@property (nonatomic, strong, readonly) NSMutableArray <__kindof YRNetworkDownloadModel *> *waitingModels;

/** 最大下载文件个数 */
@property (nonatomic, assign) NSInteger maxDownloadCount;

/** 网络请求管理单例 */
+(YRNetworkManager *)shareManager;

#pragma mark - 请求方法

- (void)requestWithHTTPMethod:(YRRequestMethod)yrRequestMethod
                    urlString:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
            requestSerializer:(YRRequestSerializer)yrRequestSerializer
           responseSerializer:(YRResponseSerializer)yrResponseSerializer
            completionHandler:(void (^) (BOOL success, id response))completionHandler;

#pragma mark - 下载方法

/**
 ===============> Description of download start <=============
 = when you wanna download a file from serverce, you can use next methods as you need.
 = there have some methods such as start, resume, cancel and so on.
 = We add the 'cancel' method to pause a task instead of suspend, because we need to resume the task when the App restart.
 = all methods will use a download model who is subclass of the 'FKNetworkingDownloadModel' for convenience.
 = and every model use a URL string as the primary key to mark a download mission or task.
 ===============> Description of download end. <=============
 */

/**
 *  this method used to start a download mission with a download model, notice that the download model can't be nil, or the download mission will not execute.
 *
 *  @param downloadModel     download model
 *  @param progress          progress of the download, track to refresh UI and ...
 *  @param completionHandler you can doing something after download mission completed, such as refresh your UI and move the file and so on.
 */
-(void)yr_startDownloadWithDownloadModel:(YRNetworkDownloadModel *)downloadModel
                                progress:(void (^)(YRNetworkDownloadModel *downloadModel))progress
                       completionHandler:(void (^)(YRNetworkDownloadModel *downloadModel, NSError * _Nullable error))completionHandler;

/**
 *  resume a download task with a download model, it will use the download model's 'resumeData'
 *
 *  @param downloadModel download model
 */
-(void)yr_resumeDownloadWithDownloadModel:(YRNetworkDownloadModel *)downloadModel;

/**
 *  suspend or cancel a download task
 *
 *  @param downloadModel download model
 */
-(void)yr_cancelDownloadTaskWithDownloadModel:(YRNetworkDownloadModel *)downloadModel;

/**
 *  check the resourece has been downloaded or not from the download model resourceURL.
 *
 *  @param downloadModel download model
 *
 *  @return YES or NO.
 */
-(BOOL)yr_hasDownloadedFileWithDownloadModel:(YRNetworkDownloadModel *)downloadModel;

/**
 *  delete local file if exist.
 *
 *  @param downloadModel download model.
 */
-(void)yr_deleteDownloadedFileWithDownloadModel:(YRNetworkDownloadModel *)downloadModel;

/**
 *  delete all downloaded files.
 */
-(void)yr_deleteAllDownloadedFiles;

/**
 *  get a download model, which is downloading with a URLString. if there is not exist a model, will return nil.
 *
 *  @param URLString URLString.
 *
 *  @return download model
 */
-(nullable YRNetworkDownloadModel *)yr_getDownloadingModelWithURLString:(NSString *)URLString;

/**
 *  get download progress information. such as download speed, progress and so on.
 *
 *  @param downloadModel download model.
 *
 *  @return progress model.
 */
-(nullable YRNetworkProgressModel *)yr_getDownloadProgressModelWithDownloadModel:(YRNetworkDownloadModel *)downloadModel;

@end

NS_ASSUME_NONNULL_END
