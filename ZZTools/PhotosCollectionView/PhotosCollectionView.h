//
//  PhotosCollectionView.h
//  ZZBaseProject
//
//  Created by zhaozhe on 16/12/7.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import <UIKit/UIKit.h>
//一行的数量
#define singleLineCount 4
//最多上传
#define maxCount 9

@protocol PhotosCollectionViewDelegate <NSObject>
/**  选完图片的回调有可能改变了高度 */
- (void)PhotosCollectionViewRefreshEndOfPhotoArray:(NSArray *)photoArray height:(CGFloat)height;
@optional
/**  点击图片默认是去浏览，如果实现代理并返回Yes，就改成删除了 */
- (void)PhotosCollectionViewDeletePhotoWithComplain:(void(^)(BOOL isDelete))complain;

@end

@interface PhotosCollectionView : UIView
/** 初始化方法（默认宽度是屏幕宽） */
- (instancetype)initWithFrame:(CGRect)frame Insets:(UIEdgeInsets)insets MinimumLineSpacing:(CGFloat)minimumLineSpacing MinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing ViewController:(UIViewController *)viewController ItemImage:(NSString *)itemImage;
/**  代理*/
@property (nonatomic,weak) id <PhotosCollectionViewDelegate> delegate;

@end
