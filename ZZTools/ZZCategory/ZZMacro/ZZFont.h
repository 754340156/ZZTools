//
//  Font.h
//  ZZCategory
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#ifndef ZZFont_h
#define ZZFont_h

#pragma mark - 通用
#define Font(x)      [UIFont systemFontOfSize:x]
#define BoldFont(x)  [UIFont boldSystemFontOfSize:x]
//收屏幕比例缩放影响的字体适配
#define AdaptedFont(x)     [UIFont systemFontOfSize:FloatAdapted(x)]
#define AdaptedBoldFont(x) [UIFont boldSystemFontOfSize:FloatAdapted(x)]

#define LightAdaptedFont(x)     [UIFont systemFontOfSize:LightAdapted(x)]
//目前流行适配 5s和6字体相同 6plus大一号
#define StandardFont(x) kScreenW != 414 ? Font(x) : Font(x + 1)


/********************定义通用颜色********************/
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]
#endif /* ZZFont_h */
