//
//  ZZAliyunTools.h
//  DiDiBeauty
//
//  Created by zhaozhe on 17/1/6.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZAliyunTools : NSObject
/**  上传单张图片到阿里云,返回缩略图 */
+ (void)ZZAliyunToolsUploadWithImage:(UIImage *)image IsAsync:(BOOL)isAsync Success:(void(^)(NSString * imageName))success Fail:(void(^)(NSError *error))fail;
/**  上传多张图片到阿里云,返回缩略图  */
+ (void)ZZAliyunToolsUploadWithImages:(NSArray<UIImage *> *)images IsAsync:(BOOL)isAsync Success:(void(^)(NSArray<NSString *> * imageNames))success Fail:(void(^)(NSError *error))fail;
/**  上传音频到阿里云,默认mp3压缩,或者自定义压缩 */
+ (void)ZZAliyunToolsUploadWithVoicePath:(NSString *)voicePath CompressConfiguration:(NSData *(^)())compressConfiguration IsAsync:(BOOL)isAsync Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail;
/**  上传视频到阿里云,默认MP4压缩,或者自定义压缩 */
+ (void)ZZAliyunToolsUploadWithVideoPath:(NSString *)videoPath CompressConfiguration:(NSData *(^)())compressConfiguration IsAsync:(BOOL)isAsync Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail;

@end
