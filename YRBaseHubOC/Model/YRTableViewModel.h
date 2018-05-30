//
//  YRTableViewModel.h
//  Shanwei
//
//  Created by hwkj on 2018/3/8.
//  Copyright © 2018年 ihongwan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UITableViewCell *(^ConfigCellBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef void(^DidSelectCellBlock)(NSIndexPath *indexPath, UITableView *tableView);

@interface YRTableViewCellModel : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) ConfigCellBlock configCellBlock;
@property (nonatomic, copy) DidSelectCellBlock didSelectCellBlock;

@end

typedef UIView *(^ConfigViewBlock)(NSInteger section, UITableView *tableView);

@interface YRTableViewSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray<YRTableViewCellModel *> *cellModelArray;

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *footerTitle;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, copy) ConfigViewBlock configHeaderViewBlock;
@property (nonatomic, copy) ConfigViewBlock configFooterViewBlock;

@end

@interface YRTableViewModel : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL renderBorder;
@property (nonatomic, strong) NSMutableArray<YRTableViewSectionModel *> *sectionModelArray;
@property (nonatomic, weak) UITableView *tableView;

@end
