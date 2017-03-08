//
//  ZZButtonsView.m
//  DiDiBeauty
//
//  Created by zhaozhe on 17/2/5.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import "ZZButtonsView.h"

@interface ZZButtonsView ()
/**  记录的当前的数组 */
@property(nonatomic,strong) NSArray * dataArray;
/**  底线 */
@property(nonatomic,strong) UIView * lineView;
/**  字体 */
@property(nonatomic,strong) UIFont * font;
@end

@implementation ZZButtonsView

- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray  ButtonColor:(UIColor *)buttonColor SelectedColor:(UIColor *)selectedColor Font:(UIFont*)font backGroundColor:(UIColor *)backGroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backGroundColor;
        [self addSubview:self.lineView];
        [self setupWithFrame:frame TitleArray:titleArray ButtonColor:buttonColor SelectedColor:selectedColor Font:font backGroundColor:backGroundColor];
        self.font = font;
    }
    return self;
}
#pragma mark - setup
- (void)setupWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray  ButtonColor:(UIColor *)buttonColor SelectedColor:(UIColor *)selectedColor Font:(UIFont*)font backGroundColor:(UIColor *)backGroundColor
{
    if (titleArray) {
        self.dataArray = titleArray;
    }
    
    CGFloat width = 0;
    if (frame.size.width == 0 || frame.size.width == kScreenW) {
        width = kScreenW /  self.dataArray.count;
    }else
    {
        width = frame.size.width / self.dataArray.count;
    }

    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width * i, 0, width, self.height - self.lineView.height);
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:buttonColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = font;
        [btn setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:backGroundColor];
        [self addSubview:btn];
        //默认点击了第一个按钮
        if (i == 0) {
            btn.selected = YES;
            self.lineView.width = [UILabel getWidthWithFont:font text:self.dataArray[i]];
            self.lineView.centerX = btn.centerX;
        }
    }
}
#pragma mark - custom method

#pragma mark - handle action
- (void)clickAction:(UIButton *)sender
{
    
    WS(weakSelf)
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZZButtonsViewClickIndex:)]) {
        for (UIView *view in self.subviews) {
            if (![view isKindOfClass:[UIButton class]]) continue;
            UIButton *btn = (UIButton *)view;
            if ([btn isEqual:sender]) {
                btn.selected = YES;
                [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([btn.titleLabel.text isEqualToString:obj]) {
                        [weakSelf.delegate ZZButtonsViewClickIndex:idx];
                    }
                }];
                //动画
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.lineView.centerX = sender.centerX;
                    weakSelf.lineView.width = [UILabel getWidthWithFont:self.font text:btn.titleLabel.text];
                }];
            }else
            {
                btn.selected = NO;
            }
        }
    }
}
/**  点击一下按钮 */
- (void)ZZButtonsViewClickWithIndex:(NSInteger)index
{
    WS(weakSelf)
    for (UIView *view in self.subviews) {
        
        if (![view isKindOfClass:[UIButton class]]) continue;
        UIButton *btn = (UIButton *)view;
        if ([btn.titleLabel.text isEqualToString:self.dataArray[index]]) {
            btn.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.lineView.centerX = btn.centerX;
                weakSelf.lineView.width = [UILabel getWidthWithFont:self.font text:btn.titleLabel.text];
            }];
        }else
        {
            btn.selected = NO;
        }
    }
    
}
#pragma mark - setter model
- (void)setLineViewColor:(UIColor *)lineViewColor
{
    _lineViewColor = lineViewColor;
    self.lineView.backgroundColor = lineViewColor;
}
- (void)setLineViewHeight:(CGFloat)lineViewHeight
{
    _lineViewHeight = lineViewHeight;
    self.lineView.height = lineViewHeight;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"0",@"1",@"2"];
    }
    return _dataArray;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kGrayColor;
        _lineView.height = 2.0f;
        _lineView.top = self.height - _lineView.height;
    }
    return _lineView;
}
@end
