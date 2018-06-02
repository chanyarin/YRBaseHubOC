//
//  YRNetworkDownloadModel.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/30.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(7_0) @interface YRNetworkProgressModel : NSObject

/*
 * data length of the bytes written.
 */
@property (nonatomic, assign) int64_t totalBytesWritten;
/*
 * the total bytes of the resource data.
 */
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
/*
 * download speed.
 */
@property (nonatomic, assign) int64_t downloadSpeed;
/*
 * download progress.
 */
@property (nonatomic, assign) float downloadProgress;
/*
 * download left time
 */
@property (nonatomic, assign) int32_t downloadLeft;

@end

NS_CLASS_AVAILABLE_IOS(7_0) @interface YRNetworkDownloadModel : NSObject

/*
 * resource URLString
 */
@property (nonatomic, copy) NSString *resourceURLString;
/*
 * fileName default is resourceURLString last component
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  file directory
 */
@property (nonatomic, copy) NSString *fileDirectory;
/**
 *  file path
 */
@property (nonatomic, copy, nullable) NSString *filePath;
/**
 *  the plist file path, the plist file include information of the download task mission.
 */
@property (nonatomic, copy, nullable) NSString *plistFilePath;
/**
 *  record the download time when receive the data from the serverce, used to calculate download speed
 */
@property (nonatomic, strong) NSDate *downloadDate;
/**
 *  check the download state when a model alloc.
 */
//@property (nonatomic, assign) FKDownloadModelState modelState;
/**
 *  resume data, marked the position of the download mission.
 */
@property (nonatomic, strong, nullable) NSData *resumeData;
/*
 * download task
 */
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *downloadTask;
/*
 * progress
 */
@property (nonatomic, strong, nullable) YRNetworkProgressModel *progressModel;
/**
 *  init method
 *
 *  @param URLString resourceURLString
 *
 *  @return download model
 */
-(instancetype)initWithResourceURLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
