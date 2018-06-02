//
//  YRNetworkManager.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/30.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "YRNetworkManager.h"

@interface AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager;

@end

@implementation AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager {
    static AFHTTPSessionManager *_singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [AFHTTPSessionManager manager];
        _singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/json", @"text/javascript", @"text/html",@"text/xml",@"image/*", nil];
    });
    return _singleton;
}

@end

NSString *const YRNetworkManagerFileName = @"yarin.network.manager";

@interface YRNetworkManager ()

/**
 *  AFNetworking manager.
 */
@property (nonatomic, strong) AFHTTPSessionManager *AFManager;

/**
 *  download root directory.
 */
@property (nonatomic, copy) NSString *downloadDirectory;

/**
 *  fileManager to manage download files
 */
@property (nonatomic, strong) NSFileManager *fileManager;

/*
 * the models for waiting for download, the elements should be FKDownloadModel and it's subClasses
 */
@property (nonatomic, strong) NSMutableArray <__kindof YRNetworkDownloadModel *> *waitingModels;

/*
 * the models whose being downloaded, the elements should be FKDownloadModel and it's subClasses
 */
@property (nonatomic, strong) NSMutableArray <__kindof YRNetworkDownloadModel *> *downloadingModels;

/*
 *  key-values dictionary of the downloadModels, format as '<NSString *key, FKDownloadModel *model>' to make constraints
 *  used to find a downloadModel from this container,
 *  when the program will terminate, container will be clear
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, __kindof YRNetworkDownloadModel *> *downloadModelsDict;

@end

NSInteger const yr_timeInterval = 5;

@implementation YRNetworkManager

#pragma mark - request method

- (void)requestWithHTTPMethod:(YRRequestMethod)yrRequestMethod
                    urlString:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
            requestSerializer:(YRRequestSerializer)yrRequestSerializer
           responseSerializer:(YRResponseSerializer)yrResponseSerializer
            completionHandler:(void (^) (BOOL success, id response))completionHandler {
    //检测网络是否可用
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                completionHandler(NO, nil);
                return ;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];
    
    AFHTTPSessionManager *afnManager = [AFHTTPSessionManager sharedManager];
    afnManager.responseSerializer = [self responseSerializerWith:yrResponseSerializer];
    
    NSString *requestMethod = [self requestMethodWith:yrRequestMethod];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWith:yrRequestSerializer];
    NSError * __autoreleasing requestSerializationError = nil;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestMethod URLString:urlString parameters:parameters error:&requestSerializationError];
//    afnManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    NSURLSessionTask *task = [afnManager dataTaskWithRequest:request
                                                  uploadProgress:nil
                                                downloadProgress:nil
                                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                   if (error) {
                                                       completionHandler(NO, nil);
                                                   } else {
                                                       NSLog(@"responseData is %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                                       NSLog(@"is---%d---response---%@",[NSJSONSerialization isValidJSONObject:responseObject],[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
                                                       completionHandler(YES, responseObject);
                                                   }
                                               }];
    [task resume];
}

- (NSString *)requestMethodWith:(YRRequestMethod)yrRequestMethod {
    switch (yrRequestMethod) {
        case YRRequestMethodGET:    return @"GET";      break;
        case YRRequestMethodPOST:   return @"POST";     break;
        case YRRequestMethodPUT:    return @"PUT";      break;
        case YRRequestMethodPATCH:  return @"PATCH";    break;
        case YRRequestMethodHEAD:   return @"HEAD";     break;
        case YRRequestMethodDELETE: return @"DELETE";   break;
        default:                    return @"GET";      break;
    }
}

- (AFHTTPRequestSerializer *)requestSerializerWith:(YRRequestSerializer)yrRequestSerializer {
    AFHTTPRequestSerializer *requestSerializer = nil;
    switch (yrRequestSerializer) {
        case YRRequestSerializerHTTP:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case YRRequestSerializerJSON:
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        default:
            break;
    }
    requestSerializer.timeoutInterval = yr_timeInterval;
    requestSerializer.allowsCellularAccess = YES;
    
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerWith:(YRResponseSerializer)yrResponseSearalizer {
    switch (yrResponseSearalizer) {
        case YRResponseSerializerHTTP:      return [AFHTTPResponseSerializer serializer];           break;
        case YRResponseSerializerJSON:      return [AFJSONResponseSerializer serializer];           break;
        case YRResponseSerializerXML:       return [AFXMLParserResponseSerializer serializer];      break;
        case YRResponseSerializerIMAGE:     return [AFPropertyListResponseSerializer serializer];   break;
        case YRResponseSerializerPLIST:     return [AFCompoundResponseSerializer serializer];       break;
        case YRResponseSerializerCOMPOUND:  return [AFImageResponseSerializer serializer];          break;
        default:                            return [AFJSONResponseSerializer serializer];           break;
    }
}

#pragma mark - download methods

-(void)yr_startDownloadWithDownloadModel:(YRNetworkDownloadModel *)downloadModel
                                progress:(void (^)(YRNetworkDownloadModel * _Nonnull))progress
                       completionHandler:(void (^)(YRNetworkDownloadModel * _Nonnull, NSError * _Nullable))completionHandler{
    
    NSString *fileName = [downloadModel.fileName componentsSeparatedByString:@"."].firstObject;
    downloadModel.fileDirectory = [self.downloadDirectory stringByAppendingPathComponent:fileName];
    downloadModel.filePath = [[self.downloadDirectory stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:downloadModel.fileName];
    downloadModel.plistFilePath = [downloadModel.fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    if (![self canBeStartDownloadTaskWithDownloadModel:downloadModel]) return;
    
    downloadModel.resumeData = [NSData dataWithContentsOfFile:downloadModel.plistFilePath];
    
    if (downloadModel.resumeData.length == 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.resourceURLString]];
        downloadModel.downloadTask = [self.AFManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            [self setValuesForDownloadModel:downloadModel withProgress:downloadProgress.fractionCompleted];
            progress(downloadModel);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:downloadModel.filePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [self yr_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                completionHandler(downloadModel, nil);
                [self deletePlistFileWithDownloadModel:downloadModel];
            }
        }];
        
    }else{
        
        downloadModel.progressModel.totalBytesWritten = [self getResumeByteWithDownloadModel:downloadModel];
        downloadModel.downloadTask = [self.AFManager downloadTaskWithResumeData:downloadModel.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            
            [self setValuesForDownloadModel:downloadModel withProgress:[self.AFManager downloadProgressForTask:downloadModel.downloadTask].fractionCompleted];
            progress(downloadModel);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadModel.filePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [self yr_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                completionHandler(downloadModel, nil);
                [self deletePlistFileWithDownloadModel:downloadModel];
            }
        }];
    }
    
    if (![self.fileManager fileExistsAtPath:self.downloadDirectory]) {
        [self.fileManager createDirectoryAtPath:self.downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self createFolderAtPath:[self.downloadDirectory stringByAppendingPathComponent:fileName]];
    [self yr_resumeDownloadWithDownloadModel:downloadModel];
}

-(void)yr_resumeDownloadWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if (downloadModel.downloadTask) {
        downloadModel.downloadDate = [NSDate date];
        [downloadModel.downloadTask resume];
        self.downloadModelsDict[downloadModel.resourceURLString] = downloadModel;
        [self.downloadingModels addObject:downloadModel];
    }
}

-(void)yr_cancelDownloadTaskWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if (!downloadModel) return;
    NSURLSessionTaskState state = downloadModel.downloadTask.state;
    if (state == NSURLSessionTaskStateRunning) {
        [downloadModel.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            downloadModel.resumeData = resumeData;
            @synchronized (self) {
                BOOL isSuc = [downloadModel.resumeData writeToFile:downloadModel.plistFilePath atomically:YES];
                [self saveTotalBytesExpectedToWriteWithDownloadModel:downloadModel];
                if (isSuc) {
                    downloadModel.resumeData = nil;
                    [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                    [self.downloadingModels removeObject:downloadModel];
                }
            }
        }];
    }
}

-(void)yr_deleteDownloadedFileWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if ([self.fileManager fileExistsAtPath:downloadModel.fileDirectory]) {
        [self.fileManager removeItemAtPath:downloadModel.fileDirectory error:nil];
    }
}

-(void)yr_deleteAllDownloadedFiles{
    if ([self.fileManager fileExistsAtPath:self.downloadDirectory]) {
        [self.fileManager removeItemAtPath:self.downloadDirectory error:nil];
    }
}

-(BOOL)yr_hasDownloadedFileWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if ([self.fileManager fileExistsAtPath:downloadModel.filePath]) {
        NSLog(@"已下载的文件...");
        return YES;
    }
    return NO;
}

-(YRNetworkDownloadModel *)yr_getDownloadingModelWithURLString:(NSString *)URLString{
    return self.downloadModelsDict[URLString];
}

-(YRNetworkProgressModel *)yr_getDownloadProgressModelWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    YRNetworkProgressModel *progressModel = downloadModel.progressModel;
    progressModel.downloadProgress = [self.AFManager downloadProgressForTask:downloadModel.downloadTask].fractionCompleted;
    return progressModel;
}

#pragma mark - private methods
-(BOOL)canBeStartDownloadTaskWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if (!downloadModel) return NO;
    if (downloadModel.downloadTask && downloadModel.downloadTask.state == NSURLSessionTaskStateRunning) return NO;
    if ([self yr_hasDownloadedFileWithDownloadModel:downloadModel]) return NO;
    return YES;
}

-(void)setValuesForDownloadModel:(YRNetworkDownloadModel *)downloadModel withProgress:(double)progress{
    NSTimeInterval interval = -1 * [downloadModel.downloadDate timeIntervalSinceNow];
    downloadModel.progressModel.totalBytesWritten = downloadModel.downloadTask.countOfBytesReceived;
    downloadModel.progressModel.totalBytesExpectedToWrite = downloadModel.downloadTask.countOfBytesExpectedToReceive;
    downloadModel.progressModel.downloadProgress = progress;
    downloadModel.progressModel.downloadSpeed = (int64_t)((downloadModel.progressModel.totalBytesWritten - [self getResumeByteWithDownloadModel:downloadModel]) / interval);
    if (downloadModel.progressModel.downloadSpeed != 0) {
        int64_t remainingContentLength = downloadModel.progressModel.totalBytesExpectedToWrite  - downloadModel.progressModel.totalBytesWritten;
        int currentLeftTime = (int)(remainingContentLength / downloadModel.progressModel.downloadSpeed);
        downloadModel.progressModel.downloadLeft = currentLeftTime;
    }
}

-(int64_t)getResumeByteWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    int64_t resumeBytes = 0;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:downloadModel.plistFilePath];
    if (dict) {
        resumeBytes = [dict[@"NSURLSessionResumeBytesReceived"] longLongValue];
    }
    return resumeBytes;
}

-(NSString *)getTmpFileNameWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    NSString *fileName = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:downloadModel.plistFilePath];
    if (dict) {
        fileName = dict[@"NSURLSessionResumeInfoTempFileName"];
    }
    return fileName;
}

-(void)createFolderAtPath:(NSString *)path{
    if ([self.fileManager fileExistsAtPath:path]) return;
    [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)deletePlistFileWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    if (downloadModel.downloadTask.countOfBytesReceived == downloadModel.downloadTask.countOfBytesExpectedToReceive) {
        [self.fileManager removeItemAtPath:downloadModel.plistFilePath error:nil];
        [self removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:downloadModel];
    }
}

-(NSString *)managerPlistFilePath{
    return [self.downloadDirectory stringByAppendingPathComponent:@"ForKidManager.plist"];
}

-(nullable NSMutableDictionary <NSString *, NSString *> *)managerPlistDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self managerPlistFilePath]];
    return dict;
}

-(void)saveTotalBytesExpectedToWriteWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    NSMutableDictionary <NSString *, NSString *> *dict = [self managerPlistDict];
    [dict setValue:[NSString stringWithFormat:@"%lld", downloadModel.downloadTask.countOfBytesExpectedToReceive] forKey:downloadModel.resourceURLString];
    [dict writeToFile:[self managerPlistFilePath] atomically:YES];
}

-(void)removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:(YRNetworkDownloadModel *)downloadModel{
    NSMutableDictionary <NSString *, NSString *> *dict = [self managerPlistDict];
    [dict removeObjectForKey:downloadModel.resourceURLString];
    [dict writeToFile:[self managerPlistFilePath] atomically:YES];
}

#pragma mark - share instance
+(YRNetworkManager *)shareManager{
    static YRNetworkManager *manager = nil;
    static dispatch_once_t sigletonOnceToken;
    dispatch_once(&sigletonOnceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _AFManager = [AFHTTPSessionManager sharedManager];
//        _AFManager = [[AFHTTPSessionManager alloc]init];
//        _AFManager.requestSerializer.timeoutInterval = 5;
//        _AFManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;//NSURLRequestUseProtocolCachePolicy;
//        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
//        _AFManager.responseSerializer.acceptableContentTypes = typeSet;
//        _AFManager.securityPolicy.allowInvalidCertificates = YES;
        
        _maxDownloadCount = 1;
        _fileManager = [NSFileManager defaultManager];
        _waitingModels = [[NSMutableArray alloc] initWithCapacity:1];
        _downloadingModels = [[NSMutableArray alloc] initWithCapacity:1];
        _downloadModelsDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        _downloadDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:YRNetworkManagerFileName];
        [_fileManager createDirectoryAtPath:_downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSDictionary <NSString *, NSString *> *plistDict = [[NSDictionary alloc] init];
        NSString *managerPlistFilePath = [_downloadDirectory stringByAppendingPathComponent:@"ForKidManager.plist"];
        [plistDict writeToFile:managerPlistFilePath atomically:YES];
    }
    return self;
}

@end
