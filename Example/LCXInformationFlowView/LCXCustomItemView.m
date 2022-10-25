//
//  LCXCustomItemView.m
//  LCXInformationFlowView_Example
//
//  Created by lengchuanxin on 2022/10/21.
//  Copyright © 2022 传鑫 冷. All rights reserved.
//

#import "LCXCustomItemView.h"
#import <Masonry/Masonry.h>

@interface LCXCustomItemView ()

@end

@implementation LCXCustomItemView

#pragma mark - Life Cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self p_initSubviews];
        [self p_initLayouts];
    }
    return self;
}

#pragma mark - Private

- (void)p_initSubviews {
    [self addSubview:self.textLabel];
}

- (void)p_initLayouts {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
}

#pragma mark - Public

#pragma mark - Event

#pragma mark - Getter/Setter

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
