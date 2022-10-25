//
//  LCXInformationFlowItemView.h
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCXInformationFlowItemView : UIView
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (void)prepareForReuse NS_REQUIRES_SUPER;
- (void)setGradientLayerHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
