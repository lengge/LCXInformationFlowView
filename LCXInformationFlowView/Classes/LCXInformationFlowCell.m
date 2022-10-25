//
//  LCXInformationFlowCell.m
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import "LCXInformationFlowCell.h"
#import "LCXInformationFlowItemView.h"

@interface LCXInformationFlowCell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<LCXInformationFlowItemView *> *itemViews;
@end

@implementation LCXInformationFlowCell

+ (NSString *)pb_reusedIdentifier {
    return [NSStringFromClass(self) stringByAppendingString:@"Identifier"];
}

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initSubviews];
        [self p_initLayouts];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for (LCXInformationFlowItemView *itemView in self.itemViews) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(flowCell:removeItemView:)]) {
            [self.delegate flowCell:self removeItemView:itemView];
        }
        [itemView removeFromSuperview];
    }
    [self.itemViews removeAllObjects];
}

#pragma mark - Private

- (void)p_initSubviews {
    [self.contentView addSubview:self.scrollView];
}

- (void)p_initLayouts {
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.scrollView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.scrollView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
}

#pragma mark - Public

- (void)reloadDataForRow:(NSInteger)row contentOffset:(CGPoint)contentOffset {
    if (!self.dataSource || !self.delegate) return;
    CGFloat x = 0;
    CGFloat h = [self.delegate heightOfCell:self atRow:row];
    NSInteger columns = [self.dataSource flowCellNumberOfColumns:self];
    for (NSInteger column = 0; column < columns; column++) {
        LCXInformationFlowItemView *itemView = [self.dataSource flowCell:self itemViewForRow:row column:column];
        CGFloat width = [self.delegate flowCell:self widthForColumn:column];
        itemView.frame = CGRectMake(x, 0, width, h);
        [self.itemViews addObject:itemView];
        if (column == 0) {
            [self.contentView addSubview:itemView];
        } else {
            [self.scrollView addSubview:itemView];
        }
        x += width;
    }
    [self.scrollView setContentSize:CGSizeMake(x, h)];
    self.scrollView.contentOffset = contentOffset;
}

- (void)setScrollViewContentOffset:(CGPoint)contentOffset {
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)setFirstItemViewGradientLayerHidden:(BOOL)hidden {
    [self.itemViews.firstObject setGradientLayerHidden:hidden];
}

- (CGPoint)findFinalContentOffset {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX <= 0 || offsetX >= maxOffsetX) return self.scrollView.contentOffset;
    CGFloat firstItemViewWidth = [self.itemViews firstObject].frame.size.width;
    CGFloat virtualOffsetX = offsetX + firstItemViewWidth;
    for (LCXInformationFlowItemView *itemView in self.itemViews) {
        if (virtualOffsetX > CGRectGetMinX(itemView.frame) && virtualOffsetX < CGRectGetMaxX(itemView.frame)) {
            CGFloat needOffsetX = (virtualOffsetX > CGRectGetMidX(itemView.frame) ? CGRectGetMaxX(itemView.frame) : CGRectGetMinX(itemView.frame)) - firstItemViewWidth;
            return CGPointMake(needOffsetX, 0);
        }
    }
    return self.scrollView.contentOffset;
}

#pragma mark - Event

#pragma mark - Getter/Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (NSMutableArray<LCXInformationFlowItemView *> *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

@end
