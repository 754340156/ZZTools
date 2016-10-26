//
//  ZZFileDataHandle.m
//  ZZTools
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "ZZFileDataHandle.h"

@implementation ZZFileDataHandle
static ZZFileDataHandle *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
/**  计算缓存 */
- (CGFloat)getDiskSize
{
    NSInteger size = 0;
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *mgr = [NSFileManager defaultManager];
    //获取到lib下面所有的子路径
    NSArray *libSubpaths = [mgr subpathsAtPath:libPath];
    for ( NSString *str in libSubpaths) {
        if (![str containsString:@"Preferences"]) {
            //拼接成完整路径
            NSString *path  =[libPath stringByAppendingPathComponent:str];
            //获取文件的属性
            NSDictionary *strAttr = [mgr attributesOfItemAtPath:path error:nil];
            //得到文件的大小
            size  = size +[strAttr[@"NSFileSize"] integerValue];
        }
    }
    return size / 1024.0 / 1024.0 ;
}
/**  清除缓存 */
- (void)clearDisk
{
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *mgr = [NSFileManager defaultManager];
    //获取到lib下面所有的子路径
    NSArray *libSubpaths = [mgr subpathsAtPath:libPath];
    for ( NSString *str in libSubpaths) {
        if (![str containsString:@"Preferences"]) {
            //拼接成完整路径
            NSString *path  =[libPath stringByAppendingPathComponent:str];
            [mgr removeItemAtPath:path error:nil];
        }
    }
}
@end
