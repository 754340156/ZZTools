//
//  CodeButton.h
//  ZZTools
//
//  Created by zhaozhe on 16/12/6.
//  Copyright © 2016年 zhaozhe. All rights reserved.
// 获取验证码的button

#import <UIKit/UIKit.h>

@class CodeButton;

typedef NSString* (^DidChangeBlock)(CodeButton *codeButton,int second);

typedef NSString* (^DidFinishedBlock)(CodeButton *codeButton,int second);

typedef void (^TouchedDownBlock)(CodeButton *codeButton,NSInteger tag);

@interface CodeButton : UIButton
{
    int _second;
    int _totalSecond;
    NSTimer *_timer;
    NSDate *_startDate;
    DidChangeBlock _didChangeBlock;
    DidFinishedBlock _didFinishedBlock;
    TouchedDownBlock _touchedDownBlock;
}

/**
 添加相应事件
 */
- (void)addToucheHandler:(TouchedDownBlock)touchHandler;

/**
 点击button变化的时候
 
 @param didChangeBlock 回调时间
 */
- (void)didChange:(DidChangeBlock)didChangeBlock;

/**
 当时间截止时候
 
 @param didFinishedBlock 计算秒数停止
 */
- (void)didFinished:(DidFinishedBlock)didFinishedBlock;

/**
 设置时长
 
 @param second 60
 */
- (void)startWithSecond:(int)second;

/**
 停止计算
 */
- (void)stop;

@end
