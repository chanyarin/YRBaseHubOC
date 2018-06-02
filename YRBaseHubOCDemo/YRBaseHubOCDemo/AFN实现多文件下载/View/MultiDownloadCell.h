//
//  MultiDownloadCell.h
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/31.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "BaseTableViewCell.h"

@class YRNetworkDownloadModel;

typedef void(^DownloadBlock)(YRNetworkDownloadModel *downloadModel);

@interface MultiDownloadCell : BaseTableViewCell

@property (nonatomic, copy) DownloadBlock downloadBlock;

@end
