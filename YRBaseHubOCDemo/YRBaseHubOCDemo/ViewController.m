//
//  ViewController.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/5/16.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "ViewController.h"
#import "YRTableViewModel.h"

#import "MultiDownloadViewController.h"
#import "AFNetworkViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YRTableViewModel *tableViewModel;
@property (nonatomic, strong) NSArray *configArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Demo测试";
    
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.delegate = self.tableViewModel;
    
    [self createTableDataSource];
    [self.tableView reloadData];
}

- (void)createTableDataSource {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    
    for (int i = 0; i < self.configArray.count; i++) {
        YRTableViewSectionModel *sectionModel = [[YRTableViewSectionModel alloc] init];
        [self.tableViewModel.sectionModelArray addObject:sectionModel];
        
        NSArray *sectionArray = self.configArray[i];
        for (int j = 0; j < sectionArray.count; j++) {
            YRTableViewCellModel *cellModel = [[YRTableViewCellModel alloc] init];
            [sectionModel.cellModelArray addObject:cellModel];
            [cellModel setConfigCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.textLabel.text = [sectionArray objectAtIndex:j];
                return cell;
            }];
            [cellModel setDidSelectCellBlock:^(NSIndexPath *indexPath, UITableView *tableView) {
                [self enterPage:indexPath];
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)enterPage:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MultiDownloadViewController *download = [[MultiDownloadViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        } else if (indexPath.row == 1) {
            AFNetworkViewController *network = [[AFNetworkViewController alloc] init];
            [self.navigationController pushViewController:network animated:YES];
        }
    }
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
    return @[@[@"AFN实现多文件下载",
               @"AFN实现网络请求"]];
}

@end
