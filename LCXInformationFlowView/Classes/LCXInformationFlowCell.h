//
//  LCXInformationFlowCell.h
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LCXInformationFlowCell;
@class LCXInformationFlowItemView;

@protocol LCXInformationFlowCellDataSource <NSObject>

@required
- (NSInteger)flowCellNumberOfColumns:(LCXInformationFlowCell *)flowCell;
- (LCXInformationFlowItemView *)flowCell:(LCXInformationFlowCell *)flowCell itemViewForRow:(NSInteger)row column:(NSInteger)column;

@end

@protocol LCXInformationFlowCellDelegate <NSObject>

- (CGFloat)flowCell:(LCXInformationFlowCell *)flowCell widthForColumn:(NSInteger)column;
- (CGFloat)heightOfCell:(LCXInformationFlowCell *)flowCell atRow:(NSInteger)row;
- (void)flowCell:(LCXInformationFlowCell *)flowCell removeItemView:(LCXInformationFlowItemView *)itemView;

@end

@interface LCXInformationFlowCell : UITableViewCell

@property (nonatomic, weak) id<LCXInformationFlowCellDataSource> dataSource;
@property (nonatomic, weak) id<LCXInformationFlowCellDelegate> delegate;

+ (NSString *)pb_reusedIdentifier;
- (void)reloadDataForRow:(NSInteger)row contentOffset:(CGPoint)contentOffset;
- (void)setScrollViewContentOffset:(CGPoint)contentOffset;
- (void)setFirstItemViewGradientLayerHidden:(BOOL)hidden;
- (CGPoint)findFinalContentOffset;

@end

NS_ASSUME_NONNULL_END
