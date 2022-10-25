//
//  LCXInformationFlowView.h
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import <UIKit/UIKit.h>
#import "LCXInformationFlowItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCXInformationFlowTableView : UITableView

@end

@class LCXInformationFlowView;

@protocol LCXInformationFlowViewDataSource <NSObject>

@required
- (NSInteger)flowViewNumberOfRows:(LCXInformationFlowView *)flowView;
- (NSInteger)flowViewNumberOfColumns:(LCXInformationFlowView *)flowView;

- (LCXInformationFlowItemView *)flowView:(LCXInformationFlowView *)flowView itemViewForRow:(NSInteger)row column:(NSInteger)column;
- (LCXInformationFlowItemView *)flowView:(LCXInformationFlowView *)flowView headerItemViewForColumn:(NSInteger)column;

@end

@protocol LCXInformationFlowViewDelegate <NSObject>

- (CGFloat)flowView:(LCXInformationFlowView *)flowView heightForRow:(NSInteger)row;
- (CGFloat)flowView:(LCXInformationFlowView *)flowView widthForColumn:(NSInteger)column;
- (CGFloat)heightOfHeaderForFlowView:(LCXInformationFlowView *)flowView;

@end

@interface LCXInformationFlowView : UIView

/// 可添加上拉和下拉刷新，不要改变tableView的delegate和dataSource
@property (nonatomic, strong, readonly) LCXInformationFlowTableView *tableView;

@property (nonatomic, weak) id<LCXInformationFlowViewDataSource> dataSource;
@property (nonatomic, weak) id<LCXInformationFlowViewDelegate> delegate;

@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, strong, nullable) UIView *footerView;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

- (void)registerClass:(nullable Class)cellClass forItemViewReuseIdentifier:(NSString *)identifier;
- (nullable __kindof LCXInformationFlowItemView *)dequeueReusableItemViewWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
