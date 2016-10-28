//
//  ZZAFNetworkingManager.h
//  ZZTools
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZAFNetworkingManager : NSObject
+ (void)netWorkWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock;
@end
