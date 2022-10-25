//
//  LCXInformationFlowSectionHeader.h
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LCXInformationFlowSectionHeader;
@class LCXInformationFlowItemView;

@protocol LCXInformationFlowSectionHeaderDataSource <NSObject>

@required
- (NSInteger)headerNumberOfColumns:(LCXInformationFlowSectionHeader *)header;

- (LCXInformationFlowItemView *)header:(LCXInformationFlowSectionHeader *)header itemViewForColumn:(NSInteger)column;

@end

@protocol LCXInformationFlowSectionHeaderDelegate <NSObject>

- (CGFloat)header:(LCXInformationFlowSectionHeader *)header widthForColumn:(NSInteger)column;

- (CGFloat)heightOfHeader:(LCXInformationFlowSectionHeader *)header;

- (void)header:(LCXInformationFlowSectionHeader *)header removeItemView:(LCXInformationFlowItemView *)itemView;

@end

@interface LCXInformationFlowSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) UIScrollView *associatedScrollView;
@property (nonatomic, weak) id<LCXInformationFlowSectionHeaderDataSource> dataSource;
@property (nonatomic, weak) id<LCXInformationFlowSectionHeaderDelegate> delegate;

+ (NSString *)pb_reusedIdentifier;

- (void)reloadDataWithContentOffset:(CGPoint)contentOffset;

- (void)setScrollViewContentOffset:(CGPoint)contentOffset;

- (void)setFirstItemViewGradientLayerHidden:(BOOL)hidden;

- (CGPoint)findFinalContentOffset;

@end

NS_ASSUME_NONNULL_END
