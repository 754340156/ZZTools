//
//  ZZProgressView.m
//  DiDiBeauty
//
//  Created by zhaozhe on 17/1/21.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import "ZZProgressView.h"

@interface ZZProgressView ()
@property(nonatomic,strong) UIView *progressView;
/**  progressRect */
@property(nonatomic,assign) CGRect  progressRect;
@end

@implementation ZZProgressView
#pragma mark - setup
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progressView.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew context:nil];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - setter and getter

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    self.backgroundColor = progressTintColor;
}
- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.progressView.backgroundColor = trackTintColor;
}
- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    //设置圆角
    [self setCornerWithRadius:self.bounds.size.height / 2.0];
    
    NSAssert(self.progressMaxValue, @"最大值不能为空");
    self.progressView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    self.progressRect = CGRectMake(0, 0, progressValue / self.progressMaxValue * self.bounds.size.width, self.bounds.size.height);
    double durationValue = (progressValue/2.0) / self.progressMaxValue + .5;
    [UIView animateWithDuration:durationValue animations:^{
        self.progressView.frame = self.progressRect;
    }];
}
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.progressView];
    }
    return _progressView;
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context

{
    CGFloat progressValue = [change.allKeys[NSKeyValueObservingOptionNew] floatValue];

    if (progressValue) {
        
        CGFloat corner =  progressValue / self.progressMaxValue  * self.bounds.size.width;
        
        if (corner < self.bounds.size.height / 2 && corner > 0) {
            [self.progressView setCornerWithRadius:corner RoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
        }else  if (corner > self.bounds.size.height / 2 &&  (self.bounds.size.width - corner) > self.bounds.size.height / 2)
        {
            [self.progressView setCornerWithRadius:self.bounds.size.height / 2 RoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
        }else if ((self.bounds.size.width - corner) < self.bounds.size.height / 2 &&  (self.bounds.size.width - corner) > 0)
        {
            [self.progressView setCornerWithRadius:self.bounds.size.height / 2 RoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
            [self.progressView setCornerWithRadius:(self.bounds.size.width - corner) RoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
        }
    }
}
#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"progressValue"];
}
@end
