//
//  YRTableViewModel.m
//  Shanwei
//
//  Created by hwkj on 2018/3/8.
//  Copyright © 2018年 ihongwan. All rights reserved.
//

#import "YRTableViewModel.h"

@implementation YRTableViewCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.height = UITableViewAutomaticDimension;
    }
    return self;
}

@end

@implementation YRTableViewSectionModel

- (instancetype)init {
    if (self = [super init]) {
        self.cellModelArray = [NSMutableArray array];
        self.headerHeight = UITableViewAutomaticDimension;
        self.footerHeight = UITableViewAutomaticDimension;
    }
    return self;
}

@end

@implementation YRTableViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.renderBorder = YES;
        self.sectionModelArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YRTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.cellModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YRTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
    ConfigCellBlock configCellBlock = cellModel.configCellBlock;
    if (configCellBlock) {
        cell = configCellBlock(indexPath, tableView);
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.rowHeight = tableView.rowHeight;
    return self.tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    YRTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    YRTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YRTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    ConfigViewBlock configHeaderViewBlock = sectionModel.configHeaderViewBlock;
    if (configHeaderViewBlock) {
        return configHeaderViewBlock(section, tableView);
    } else {
        return [[UIView alloc] init];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YRTableViewSectionModel *sectionModel = [self sectionModelAtSection:section];
    ConfigViewBlock configFooterViewBlock = sectionModel.configFooterViewBlock;
    if (configFooterViewBlock) {
        return configFooterViewBlock(section, tableView);
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YRTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YRTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    DidSelectCellBlock didSelectCellBlock = cellModel.didSelectCellBlock;
    if (didSelectCellBlock) {
        didSelectCellBlock(indexPath, tableView);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.renderBorder) {
        if ([cell respondsToSelector:@selector(tintColor)]) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            //圆角半径
            CGFloat cornerRadius = 5;
            //单元格底部是否添加分隔线
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                //分区内只有一个单元格时，直接绘制圆角边框
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                //分区内第一个单元格
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                //分区内最后一个单元格
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                //分区中部单元格，绘制矩形边框
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色设置
            layer.fillColor = [UIColor whiteColor].CGColor;
            layer.strokeColor = [UIColor clearColor].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+15, bounds.size.height-lineHeight, bounds.size.width-30, lineHeight);
                lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
                [layer addSublayer:lineLayer];
            }
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:bounds];
            [backgroundView.layer insertSublayer:layer atIndex:0];
            backgroundView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = backgroundView;
        }
    }
}

#pragma mark - private method

- (YRTableViewSectionModel *)sectionModelAtSection:(NSInteger)section {
    @try {
        YRTableViewSectionModel *sectionModel = self.sectionModelArray[section];
        return sectionModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (YRTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        YRTableViewSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
        YRTableViewCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
        return cellModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
