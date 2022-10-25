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
        _flowView = [[LCXInformationFlowView alloc] initWithFrame:CGRectZero];
        _flowView.delegate = self;
        _flowView.dataSource = self;
        [_flowView registerClass:[LCXCustomItemView class] forItemViewReuseIdentifier:@"LCXCustomItemView"];
        [_flowView registerClass:[LCXCustomItemView class] forItemViewReuseIdentifier:@"LCXCustomItemViewHeader"];
    }
    return _flowView;
}

@end
