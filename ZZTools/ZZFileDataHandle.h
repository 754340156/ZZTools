//
//  ZZFileDataHandle.h
//  ZZTools
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//  文件句柄,单例类做缓存计算和清除

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZZFileDataHandle : NSObject
+ (instancetype)sharedInstance;
/**  计算缓存 */
- (CGFloat)getDiskSize;
/**  清除缓存 */
- (void)clearDisk;
@end
