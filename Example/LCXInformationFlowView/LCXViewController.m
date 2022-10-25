//
//  LCXViewController.m
//  LCXInformationFlowView
//
//  Created by 传鑫 冷 on 10/21/2022.
//  Copyright (c) 2022 传鑫 冷. All rights reserved.
//

#import "LCXViewController.h"
#import "LCXCustomItemView.h"
#import <LCXInformationFlowView/LCXInformationFlowView.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@interface LCXDataItem : NSObject
@property (nonatomic, copy) NSArray<NSString *> *items;
@end

@implementation LCXDataItem

- (instancetype)initWithNum:(NSString *)num {
    if (self = [super init]) {
        _items = @[num, @"乔峰", @"段誉", @"虚卒", @"逍遥子", @"扫地僧", @"达摩", @"观音", @"玉帝", @"皇帝", @"三皇", @"五帝", @"秦始皇", @"哈喽"];
    }
    return self;
}

@end

@interface LCXViewController () <LCXInformationFlowViewDataSource, LCXInformationFlowViewDelegate>
@property (nonatomic, strong) LCXInformationFlowView *flowView;
@property (nonatomic, copy) NSArray<LCXDataItem *> *datas;
@property (nonatomic, copy) NSArray<NSString *> *headerItems;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation LCXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.flowView];
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.top.mas_equalTo(self.mas_topLayoutGuide);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        }
        make.left.right.mas_equalTo(0);
    }];

    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger idx = 0; idx < 50; idx++) {
        [datas addObject:[[LCXDataItem alloc] initWithNum:[@(idx) stringValue]]];
    }
    
    self.headerItems = @[@"序号", @"名称", @"年龄", @"地址", @"手机号", @"城市", @"区域", @"地级市", @"县城", @"村庄", @"面貌", @"状态", @"班级", @"职务"];
    self.datas = datas;
    
    [self.flowView reloadData];
    
    self.flowView.headerView = self.headerView;
    self.flowView.footerView = self.footerView;
    
    __weak typeof(self) weakSelf = self;
    self.flowView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.flowView.tableView.mj_header endRefreshing];
            [weakSelf.flowView.tableView.mj_footer endRefreshing];
        });
    }];
    
    self.flowView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.flowView.tableView.mj_header endRefreshing];
            [weakSelf.flowView.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - LCXInformationFlowViewDataSource & LCXInformationFlowViewDelegate

- (NSInteger)flowViewNumberOfRows:(LCXInformationFlowView *)flowView {
    return self.datas.count;
}

- (NSInteger)flowViewNumberOfColumns:(LCXInformationFlowView *)flowView {
    return self.datas.firstObject.items.count;
}

- (LCXInformationFlowItemView *)flowView:(LCXInformationFlowView *)flowView itemViewForRow:(NSInteger)row column:(NSInteger)column {
    LCXCustomItemView *itemView = [flowView dequeueReusableItemViewWithIdentifier:@"LCXCustomItemView"];
    itemView.textLabel.text = self.datas[row].items[column];
    return itemView;
}

- (LCXInformationFlowItemView *)flowView:(LCXInformationFlowView *)flowView headerItemViewForColumn:(NSInteger)column {
    LCXCustomItemView *itemView = [flowView dequeueReusableItemViewWithIdentifier:@"LCXCustomItemViewHeader"];
    itemView.textLabel.text = self.headerItems[column];
    return itemView;
}

- (CGFloat)flowView:(LCXInformationFlowView *)flowView heightForRow:(NSInteger)row {
    return 44;
}

- (CGFloat)flowView:(LCXInformationFlowView *)flowView widthForColumn:(NSInteger)column {
    return 80;
}

- (CGFloat)heightOfHeaderForFlowView:(LCXInformationFlowView *)flowView {
    return 35;
}

- (LCXInformationFlowView *)flowView {
    if (!_flowView) {
        _flowView = [[LCXInformationFlowView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _flowView.delegate = self;
        _flowView.dataSource = self;
        [_flowView registerClass:[LCXCustomItemView class] forItemViewReuseIdentifier:@"LCXCustomItemView"];
        [_flowView registerClass:[LCXCustomItemView class] forItemViewReuseIdentifier:@"LCXCustomItemViewHeader"];
    }
    return _flowView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
        _headerView.backgroundColor = [UIColor redColor];
        UILabel *label = [UILabel new];
        label.text = @"HeaderView";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
        _footerView.backgroundColor = [UIColor yellowColor];
        UILabel *label = [UILabel new];
        label.text = @"FooterView";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        [_footerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _footerView;
}

@end
