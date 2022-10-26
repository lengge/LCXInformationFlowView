//
//  LCXInformationFlowView.m
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import "LCXInformationFlowView.h"
#import "LCXInformationFlowCell.h"
#import "LCXInformationFlowSectionHeader.h"
#import "LCXInformationFlowItemView+Private.h"

@interface LCXInformationFlowTableView ()
- (void)lcx_setDelegate:(id<UITableViewDelegate>)delegate;
- (void)lcx_setDataSource:(id<UITableViewDataSource>)dataSource;
@end

@implementation LCXInformationFlowTableView

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    
}

- (void)lcx_setDelegate:(id<UITableViewDelegate>)delegate {
    [super setDelegate:delegate];
}

- (void)lcx_setDataSource:(id<UITableViewDataSource>)dataSource {
    [super setDataSource:dataSource];
}

@end

@interface LCXInformationFlowView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
LCXInformationFlowCellDelegate,
LCXInformationFlowCellDataSource,
LCXInformationFlowSectionHeaderDelegate,
LCXInformationFlowSectionHeaderDataSource
>
@property (nonatomic, strong) LCXInformationFlowTableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<LCXInformationFlowItemView *> *> *reusableItemViewDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *reuseClassDict;
@property (nonatomic, assign) CGPoint horizontalContentOffset;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@end

@implementation LCXInformationFlowView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _horizontalContentOffset = CGPointZero;
        _tableViewStyle = style;
        [self p_initSubviews];
        [self p_initLayouts];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithFrame:CGRectZero style:UITableViewStylePlain];
}

#pragma mark - Private

- (void)p_initSubviews {
    [self addSubview:self.scrollView];
    [self addSubview:self.tableView];
    [self.tableView addGestureRecognizer:self.scrollView.panGestureRecognizer];
}

- (void)p_initLayouts {
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

#pragma mark - Public

- (void)registerClass:(Class)cellClass forItemViewReuseIdentifier:(NSString *)identifier {
    [self.reuseClassDict setObject:cellClass forKey:identifier];
}

- (__kindof LCXInformationFlowItemView *)dequeueReusableItemViewWithIdentifier:(NSString *)identifier {
    NSMutableArray<LCXInformationFlowItemView *> *queue = self.reusableItemViewDict[identifier];
    if (queue == nil) {
        queue = [NSMutableArray array];
        self.reusableItemViewDict[identifier] = queue;
    }
    
    if (queue.count > 0) {
        LCXInformationFlowItemView *itemView = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        return itemView;
    }
    
    Class cellClass = self.reuseClassDict[identifier];
    if (cellClass) {
        LCXInformationFlowItemView *itemView = [[cellClass alloc] initWithReuseIdentifier:identifier];
        return itemView;
    }
    
    return nil;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Event

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowViewNumberOfRows:)]) {
        return [self.dataSource flowViewNumberOfRows:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCXInformationFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:[LCXInformationFlowCell pb_reusedIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    cell.dataSource = self;
    [cell reloadDataForRow:indexPath.item contentOffset:self.horizontalContentOffset];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowView:heightForRow:)]) {
        return [self.delegate flowView:self heightForRow:indexPath.item];
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LCXInformationFlowSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LCXInformationFlowSectionHeader pb_reusedIdentifier]];
    header.delegate = self;
    header.dataSource = self;
    header.associatedScrollView = self.scrollView;
    [header reloadDataWithContentOffset:self.horizontalContentOffset];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightOfHeaderForFlowView:)]) {
        return [self.delegate heightOfHeaderForFlowView:self];
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSArray *visibleCells = [self.tableView visibleCells];
        for (LCXInformationFlowCell *cell in visibleCells) {
            [cell setFirstItemViewGradientLayerHidden:NO];
        }
        
        LCXInformationFlowSectionHeader *header = (LCXInformationFlowSectionHeader *)[self.tableView headerViewForSection:0];
        [header setFirstItemViewGradientLayerHidden:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        _horizontalContentOffset = scrollView.contentOffset;
        NSArray *visibleCells = [self.tableView visibleCells];
        for (LCXInformationFlowCell *cell in visibleCells) {
            [cell setScrollViewContentOffset:scrollView.contentOffset];
        }
        
        LCXInformationFlowSectionHeader *header = (LCXInformationFlowSectionHeader *)[self.tableView headerViewForSection:0];
        [header setScrollViewContentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (scrollView == self.scrollView && dragToDragStop) {
            LCXInformationFlowSectionHeader *header = (LCXInformationFlowSectionHeader *)[self.tableView headerViewForSection:0];
            if (header) {
                [header setFirstItemViewGradientLayerHidden:YES];
                CGPoint findFinalContentOffset = [header findFinalContentOffset];
                [self.scrollView setContentOffset:findFinalContentOffset animated:YES];
            } else {
                LCXInformationFlowCell *cell = [[self.tableView visibleCells] firstObject];
                CGPoint findFinalContentOffset = [cell findFinalContentOffset];
                [self.scrollView setContentOffset:findFinalContentOffset animated:YES];
            }
            
            NSArray *visibleCells = [self.tableView visibleCells];
            for (LCXInformationFlowCell *cell in visibleCells) {
                [cell setFirstItemViewGradientLayerHidden:YES];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollView == self.scrollView && scrollToScrollStop) {
        LCXInformationFlowSectionHeader *header = (LCXInformationFlowSectionHeader *)[self.tableView headerViewForSection:0];
        if (header) {
            [header setFirstItemViewGradientLayerHidden:YES];
            CGPoint findFinalContentOffset = [header findFinalContentOffset];
            [self.scrollView setContentOffset:findFinalContentOffset animated:YES];
        } else {
            LCXInformationFlowCell *cell = [[self.tableView visibleCells] firstObject];
            CGPoint findFinalContentOffset = [cell findFinalContentOffset];
            [self.scrollView setContentOffset:findFinalContentOffset animated:YES];
        }
        
        NSArray *visibleCells = [self.tableView visibleCells];
        for (LCXInformationFlowCell *cell in visibleCells) {
            [cell setFirstItemViewGradientLayerHidden:YES];
        }
    }
}

#pragma mark - LCXInformationFlowCellDataSource & LCXInformationFlowCellDelegate

- (NSInteger)flowCellNumberOfColumns:(LCXInformationFlowCell *)flowCell {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowViewNumberOfColumns:)]) {
        return [self.dataSource flowViewNumberOfColumns:self];
    }
    return 0;
}

- (LCXInformationFlowItemView *)flowCell:(LCXInformationFlowCell *)flowCell itemViewForRow:(NSInteger)row column:(NSInteger)column {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowView:itemViewForRow:column:)]) {
        LCXInformationFlowItemView *itemView = [self.dataSource flowView:self itemViewForRow:row column:column];
        __weak typeof(self) weakSelf = self;
        itemView.tapGestureActionBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(flowView:didSelectItemAtRow:column:)]) {
                [weakSelf.delegate flowView:self didSelectItemAtRow:row column:column];
            }
        };
        return itemView;
    }
    return [LCXInformationFlowItemView new];
}

- (CGFloat)flowCell:(LCXInformationFlowCell *)flowCell widthForColumn:(NSInteger)column {
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowView:widthForColumn:)]) {
        return [self.delegate flowView:self widthForColumn:column];
    }
    return 80;
}

- (CGFloat)heightOfCell:(LCXInformationFlowCell *)flowCell atRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowView:heightForRow:)]) {
        return [self.delegate flowView:self heightForRow:row];
    }
    return 44;
}

- (void)flowCell:(LCXInformationFlowCell *)flowCell removeItemView:(LCXInformationFlowItemView *)itemView {
    NSMutableArray<LCXInformationFlowItemView *> *queue = self.reusableItemViewDict[itemView.reuseIdentifier];
    if (queue != nil) {
        [queue addObject:itemView];
    }
}

#pragma mark - LCXInformationFlowSectionHeader & LCXInformationFlowSectionHeaderDelegate

- (NSInteger)headerNumberOfColumns:(LCXInformationFlowSectionHeader *)header {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowViewNumberOfColumns:)]) {
        return [self.dataSource flowViewNumberOfColumns:self];
    }
    return 0;
}

- (LCXInformationFlowItemView *)header:(LCXInformationFlowSectionHeader *)header itemViewForColumn:(NSInteger)column {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowView:headerItemViewForColumn:)]) {
        LCXInformationFlowItemView *itemView = [self.dataSource flowView:self headerItemViewForColumn:column];
        __weak typeof(self) weakSelf = self;
        itemView.tapGestureActionBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(flowView:didSelectHeaderItemAtColumn:)]) {
                [weakSelf.delegate flowView:self didSelectHeaderItemAtColumn:column];
            }
        };
        return itemView;
    }
    return [LCXInformationFlowItemView new];
}

- (CGFloat)header:(LCXInformationFlowSectionHeader *)header widthForColumn:(NSInteger)column {
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowView:widthForColumn:)]) {
        return [self.delegate flowView:self widthForColumn:column];
    }
    return 80;
}

- (CGFloat)heightOfHeader:(LCXInformationFlowSectionHeader *)header {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightOfHeaderForFlowView:)]) {
        return [self.delegate heightOfHeaderForFlowView:self];
    }
    return 44;
}

- (void)header:(LCXInformationFlowSectionHeader *)header removeItemView:(LCXInformationFlowItemView *)itemView {
    NSMutableArray<LCXInformationFlowItemView *> *queue = self.reusableItemViewDict[itemView.reuseIdentifier];
    if (queue != nil) {
        [queue addObject:itemView];
    }
}

#pragma mark - Getter/Setter

- (LCXInformationFlowTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LCXInformationFlowTableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        [_tableView lcx_setDelegate:self];
        [_tableView lcx_setDataSource:self];
        [_tableView registerClass:[LCXInformationFlowCell class] forCellReuseIdentifier:[LCXInformationFlowCell pb_reusedIdentifier]];
        [_tableView registerClass:[LCXInformationFlowSectionHeader class] forHeaderFooterViewReuseIdentifier:[LCXInformationFlowSectionHeader pb_reusedIdentifier]];
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableDictionary<NSString *,NSMutableArray<LCXInformationFlowItemView *> *> *)reusableItemViewDict {
    if (!_reusableItemViewDict) {
        _reusableItemViewDict = [NSMutableDictionary dictionary];
    }
    return _reusableItemViewDict;
}

- (NSMutableDictionary<NSString *,Class> *)reuseClassDict {
    if (!_reuseClassDict) {
        _reuseClassDict = [NSMutableDictionary dictionary];
    }
    return _reuseClassDict;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    [self reloadData];
}

- (void)setFooterView:(UIView *)footerView {
    _footerView = footerView;
    self.tableView.tableFooterView = footerView;
    [self reloadData];
}

@end
