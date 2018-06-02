//
//  MultiDownloadViewController.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/30.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "MultiDownloadViewController.h"
#import "YRNetworkManager.h"
#import "MultiDownloadCell.h"
#import "YRTableViewModel.h"

@interface MultiDownloadViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YRTableViewModel *tableViewModel;
@property (nonatomic, strong) NSArray *configArray;

@property (nonatomic, strong) NSMutableArray *downloadModelArray;

- (IBAction)testNetwork:(UIButton *)sender;
@end

@implementation MultiDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"AFN实现多文件下载";
    
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.delegate = self.tableViewModel;
    
    for (int i = 0; i < self.configArray.count; i++) {
        NSString *urlString = self.configArray[i];
        YRNetworkDownloadModel *downloadModel = [[YRNetworkDownloadModel alloc] initWithResourceURLString:urlString];
        [self.downloadModelArray addObject:downloadModel];
    }
    
    [self createTableDataSource];
    [self.tableView reloadData];
}

- (void)createTableDataSource {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    
    YRTableViewSectionModel *sectionModel = [[YRTableViewSectionModel alloc] init];
    [self.tableViewModel.sectionModelArray addObject:sectionModel];
    
    for (int i = 0; i < self.configArray.count; i++) {
        YRTableViewCellModel *cellModel = [[YRTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = 65;
        [cellModel setConfigCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            MultiDownloadCell *cell = [MultiDownloadCell createCellWithTableView:tableView];
            [cell configCellData:self.downloadModelArray[i]];
            [cell setDownloadBlock:^(YRNetworkDownloadModel *downModel) {
                [self startDownload:downModel];
            }];
            return cell;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startDownload:(YRNetworkDownloadModel *)downModel {
    YRNetworkManager *manager = [YRNetworkManager shareManager];
    [manager yr_startDownloadWithDownloadModel:downModel progress:^(YRNetworkDownloadModel * _Nonnull downloadModel) {
        [self.downloadModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRNetworkDownloadModel *down = (YRNetworkDownloadModel *)obj;
            if ([down.resourceURLString isEqualToString:downloadModel.resourceURLString]) {
                [self.downloadModelArray replaceObjectAtIndex:idx withObject:downloadModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createTableDataSource];
                    [self.tableView reloadData];
                });
                *stop = YES;
            }
        }];
    } completionHandler:^(YRNetworkDownloadModel * _Nonnull downloadModel, NSError * _Nullable error) {
        
    }];
    
}

#pragma mark - getters and setters

- (YRTableViewModel *)tableViewModel {
    if (!_tableViewModel) {
        _tableViewModel = [[YRTableViewModel alloc] init];
        _tableViewModel.tableView = self.tableView;
    }
    return _tableViewModel;
}

- (NSArray *)configArray {
    return @[@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg",
             @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.4.0.dmg",
             @"http://124.192.151.155/cdn/pcclient/20180329/17/08/iQIYIMedia_000.dmg"];
}

- (NSMutableArray *)downloadModelArray {
    if (!_downloadModelArray) {
        _downloadModelArray = [[NSMutableArray alloc] init];
    }
    return _downloadModelArray;
}

- (IBAction)testNetwork:(UIButton *)sender {
}

@end
