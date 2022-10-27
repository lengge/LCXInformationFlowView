//
//  LCXInformationFlowItemView.m
//  LCXInformationFlowView
//
//  Created by lengchuanxin on 2022/10/21.
//

#import "LCXInformationFlowItemView.h"

@interface LCXInformationFlowItemView ()
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation LCXInformationFlowItemView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:@"LCXInformationFlowItemView"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithReuseIdentifier:@"LCXInformationFlowItemView"];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        _reuseIdentifier = reuseIdentifier;
        [self.layer addSublayer:self.gradientLayer];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(self.frame.size.width, 0, 8, self.frame.size.height);
}

#pragma mark - Private

#pragma mark - Public

- (void)prepareForReuse { }

- (void)setGradientLayerHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.25 animations:^{
        self.gradientLayer.opacity = hidden ? 0 : 1;
    }];
}

#pragma mark - Event

- (void)tapGestureAction {
    if (_tapGestureActionBlock) {
        _tapGestureActionBlock();
    }
}

#pragma mark - Getter/Setter

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.opacity = 0;
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.colors = @[
            (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor,
            (__bridge id)[UIColor clearColor].CGColor,
            
        ];
    }
    return _gradientLayer;
}

@end
