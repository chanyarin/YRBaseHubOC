//
//  MultiDownloadCell.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/31.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "MultiDownloadCell.h"
#import "YRNetworkDownloadModel.h"

@interface MultiDownloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) YRNetworkDownloadModel *downloadModel;

- (IBAction)downloadBtnClick:(UIButton *)sender;
@end

@implementation MultiDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(id)data {
    self.downloadModel = (YRNetworkDownloadModel *)data;
    self.nameLabel.text = self.downloadModel.fileName;
    NSLog(@"url---%@---progress--%f",[self.downloadModel.resourceURLString lastPathComponent],self.downloadModel.progressModel.downloadProgress);
    self.progressView.progress = self.downloadModel.progressModel.downloadProgress;
}

- (IBAction)downloadBtnClick:(UIButton *)sender {
    if (self.downloadBlock) {
        self.downloadBlock(self.downloadModel);
    }
}
@end
