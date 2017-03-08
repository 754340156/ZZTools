//
//  ZZProgressView.h
//  DiDiBeauty
//
//  Created by zhaozhe on 17/1/21.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZProgressView : UIView
/**  进度值 */
@property(nonatomic,assign) CGFloat progressValue;
/**  最大值 */
@property(nonatomic,assign) CGFloat progressMaxValue;
/**  进度条颜色 */
@property(nonatomic,strong) UIColor *trackTintColor;
/**  背景颜色 */
@property(nonatomic,strong) UIColor *progressTintColor;
/**  边框颜色 */
@property(nonatomic,strong) UIColor *borderColor;
/**  边框宽度 */
@property(nonatomic,assign) CGFloat borderWidth;

@end
