//
//  ZZAliyunTools.m
//  DiDiBeauty
//
//  Created by zhaozhe on 17/1/6.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import "ZZAliyunTools.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
//明文
static NSString *const AccessKey = @"your-key";
//密文
static NSString *const SecretKey = @"your-secret";
//bucket
static NSString *const BucketName = @"your-bucket";
//服务器
static NSString *const AliYunHost = @"http://oss-cn-shenzhen.aliyuncs.com/";
//
static NSString *kTempFolder = @"temp";
@implementation ZZAliyunTools

/**  上传单张图片到阿里云,返回缩略图 */
+ (void)ZZAliyunToolsUploadWithImage:(UIImage *)image IsAsync:(BOOL)isAsync Success:(void(^)(NSString * imageName))success Fail:(void(^)(NSError *error))fail
{
    [self UploadWithImages:@[image] IsAsync:isAsync Success:^(NSArray<NSString *> *imageNames) {
        if (success) {
            success([imageNames firstObject]);
        }
    } Fail:fail];
}
/**  上传多张图片到阿里云,返回缩略图  */
+ (void)ZZAliyunToolsUploadWithImages:(NSArray<UIImage *> *)images IsAsync:(BOOL)isAsync Success:(void(^)(NSArray<NSString *> * imageNames))success Fail:(void(^)(NSError *error))fail
{
    [self UploadWithImages:images IsAsync:isAsync Success:success Fail:fail];
}
/**  上传音频到阿里云,默认mp3压缩,或者自定义压缩 */
+ (void)ZZAliyunToolsUploadWithVoicePath:(NSString *)voicePath CompressConfiguration:(NSData *(^)())compressConfiguration IsAsync:(BOOL)isAsync Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail
{
    if (isAsync) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [self UploadWithVoicePath:voicePath CompressConfiguration:compressConfiguration Progress:^(CGFloat uploadProgress) {
               dispatch_async(dispatch_get_main_queue(), ^{
                    progress(uploadProgress);
               });
           } Success:^{
               dispatch_async(dispatch_get_main_queue(), ^{
                    success();
               });
           } Fail:^(NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                    fail(error);
               });
           }];
        });
    }else
    {
        [self UploadWithVoicePath:voicePath CompressConfiguration:compressConfiguration Progress:progress Success:success Fail:fail];
    }
    

}
/**  上传视频到阿里云,默认MP4压缩,或者自定义压缩 */
+ (void)ZZAliyunToolsUploadWithVideoPath:(NSString *)videoPath CompressConfiguration:(NSData *(^)())compressConfiguration IsAsync:(BOOL)isAsync Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail
{
    if (isAsync) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self UploadWithVideoPath:videoPath CompressConfiguration:compressConfiguration Progress:^(CGFloat uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(uploadProgress);
                });
            } Success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
            } Fail:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(error);
                });
            }];
        });
    }else
    {
        [self UploadWithVideoPath:videoPath CompressConfiguration:compressConfiguration Progress:progress Success:success Fail:fail];
    }
}

#pragma mark - 核心方法
+ (void)UploadWithImages:(NSArray *)images IsAsync:(BOOL)isAsync Success:(void(^)(NSArray<NSString *> * imageNames))success Fail:(void(^)(NSError *error))fail
{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey                                                                                                            secretKey:SecretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = BucketName;
                NSString *imageName = [kTempFolder stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                put.objectKey = imageName;
                [callBackNames addObject:imageName];
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (isAsync && image == images.lastObject) {
                    if (!putTask.error) {
                        if (success) {
                            success(callBackNames);
                        }
                    }else
                    {
                        if (fail) {
                            fail(putTask.error);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (success) {
            success(callBackNames);
        }
    }
}
+ (void)UploadWithVoicePath:(NSString *)voicePath CompressConfiguration:(NSData *(^)())compressConfiguration Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail
{
    if (!voicePath && voicePath.length <= 0) return;
    //转码
    NSString *path = [self audioPCMtoMP3:voicePath DateString:[NSDate currentTime]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = BucketName;
    request.uploadingData = data;
    request.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress((CGFloat)totalByteSent / totalBytesExpectedToSend);
        }
    };
    
    request.objectKey = [NSString stringWithFormat:@"audiofile/%@_audio_%d.mp3",[NSDate currentTime],((arc4random()% 100000000) + 10000)];
    
    OSSClientConfiguration * configuration = [OSSClientConfiguration new];
    configuration.maxRetryCount = 3;
    configuration.enableBackgroundTransmitService = NO;
    configuration.timeoutIntervalForRequest = 15;
    configuration.timeoutIntervalForResource = 24 * 60 * 60;
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey                                                                                                            secretKey:SecretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential clientConfiguration:configuration];
    OSSTask * task = [client putObject:request];
    [[task continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error) {
            if (success) success();
        }else
        {
            if (fail) fail(task.error);
        }
        return  nil;
    }]waitUntilFinished];
}
+ (void)UploadWithVideoPath:(NSString *)videoPath CompressConfiguration:(NSData *(^)())compressConfiguration Progress:(void(^)(CGFloat uploadProgress))progress Success:(void(^)())success Fail:(void(^)(NSError *error))fail
{
    if (!videoPath && videoPath.length <= 0) return;
    //转码
    NSURL *url = [self convert2Mp4:[NSURL URLWithString:videoPath]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = BucketName;
    request.uploadingData = data;
    request.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value2", @"x-oss-meta-name2", nil];
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress((CGFloat)totalByteSent / totalBytesExpectedToSend);
        }
    };
    
    request.objectKey = [NSString stringWithFormat:@"videofile/%@_video_%d.mp4",[NSDate currentTime],((arc4random()% 100000000) + 10000)];
    OSSClientConfiguration * configuration = [OSSClientConfiguration new];
    configuration.maxRetryCount = 3;
    configuration.enableBackgroundTransmitService = NO;
    configuration.timeoutIntervalForRequest = 15;
    configuration.timeoutIntervalForResource = 24 * 60 * 60;
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey                                                                                                            secretKey:SecretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential clientConfiguration:configuration];
    OSSTask * task = [client putObject:request];
    [[task continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error) {
            if (success) success();
        }else
        {
            if (fail) fail(task.error);
        }
        return  nil;
    }]waitUntilFinished];
}
#pragma mark - 转码
+ (NSString *)audioPCMtoMP3:(NSString *)wavPath DateString:(NSString *)dateString {
    NSString *cafFilePath = wavPath;
    
    NSString *mp3FilePath = [self FilePathInLibraryWithName:[NSString stringWithFormat:@"Caches/%@.wav",dateString]];;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除原MP3文件");
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
    }
}
//转成mp4
+ (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]                                         initWithAsset:avAsset                                               presetName:AVAssetExportPreset640x480];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);        //        [self showHudInView:self.view hint:@"正在压缩"];        //        __weak typeof(self) weakSelf = self;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{            //            [weakSelf hideHud];
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout");        }
        if (wait) {
            wait = nil;        }    }
    return mp4Url;
}
+ (NSString *)FilePathInLibraryWithName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibraryDirectory = [paths objectAtIndex:0];
    return [LibraryDirectory stringByAppendingPathComponent:name];
}
@end
