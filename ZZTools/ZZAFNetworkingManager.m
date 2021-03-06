//
//  ZZAFNetworkingManager.m
//  ZZTools
//
//  Created by zhaozhe on 16/10/26.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "ZZAFNetworkingManager.h"
#import <AFNetworking/AFNetworking.h>
@implementation ZZAFNetworkingManager
+ (void)netWorkWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *encodingString = [@"这里写网络接口公共的api" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     NSString *apiString = [NSString stringWithFormat:@"%@%@",encodingString,urlString];
    [manager POST:apiString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}
@end
