//
//  LCXInformationFlowItemView+Private.h
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/26.
//

#import "LCXInformationFlowItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCXInformationFlowItemView ()
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, copy, nullable) void(^tapGestureActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
