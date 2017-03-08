//
//  ZZButtonsView.h
//  DiDiBeauty
//
//  Created by zhaozhe on 17/2/5.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZButtonsViewDelegate <NSObject>
/**  点击按钮 */
- (void)ZZButtonsViewClickIndex:(NSInteger)index;


@end

@interface ZZButtonsView : UIView
- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray  ButtonColor:(UIColor *)buttonColor SelectedColor:(UIColor *)selectedColor Font:(UIFont*)font backGroundColor:(UIColor *)backGroundColor;
/**  代理*/
@property (nonatomic,weak) id <ZZButtonsViewDelegate> delegate;
/**  底线的颜色,默认灰色 */
@property(nonatomic,strong) UIColor * lineViewColor;
/**  底线的高度,默认2 */
@property(nonatomic,assign) CGFloat lineViewHeight;

/**  点击一下按钮 */
- (void)ZZButtonsViewClickWithIndex:(NSInteger)index;
@end
