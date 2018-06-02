//
//  BaseTableViewCell.h
//  Shanwei
//
//  Created by hwkj on 2018/3/10.
//  Copyright © 2018年 ihongwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)configCellData:(id)data;

@end
