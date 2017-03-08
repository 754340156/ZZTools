//
//  PhotosCollectionView.m
//  ZZBaseProject
//
//  Created by zhaozhe on 16/12/7.
//  Copyright © 2016年 zhaozhe. All rights reserved.
//

#import "PhotosCollectionView.h"
#import "PhotosCollectionViewCell.h"
#import "TZImagePickerController.h"
#import <Masonry/Masonry.h>
static NSString * itemImageStr = @"";

static CGFloat itemH = 0;
static CGFloat itemW = 0;
static CGFloat PCVmargin = 0;
static CGFloat insetTop = 0;
static CGFloat insetBottom = 0;
@interface PhotosCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
/**  添加照片 */
@property(nonatomic,strong) UICollectionView * collectionView;
/**  选择图片数组 */
@property(nonatomic,strong) NSMutableArray * selectedPhotos;
/**  phasset图片数组 */
@property(nonatomic,strong) NSMutableArray * selectedAssets;
/**  传入控制器 */
@property(nonatomic,weak) UIViewController * viewController;
@end

@implementation PhotosCollectionView

/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame Insets:(UIEdgeInsets)insets MinimumLineSpacing:(CGFloat)minimumLineSpacing MinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing ViewController:(UIViewController *)viewController ItemImage:(NSString *)itemImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat itemHeight = ([UIScreen mainScreen].bounds.size.width - insets.left - insets.right - (singleLineCount - 1) * minimumInteritemSpacing) / singleLineCount;
        self.viewController = viewController;
        itemImageStr = itemImage;
        itemH = itemHeight;
        itemW = itemHeight;
        PCVmargin = minimumLineSpacing;
        insetTop = insets.top;
        insetBottom = insets.bottom;
        [self setupWithInsets:insets MinimumLineSpacing:minimumLineSpacing MinimumInteritemSpacing:minimumInteritemSpacing];
        
    }
    return self;
}
#pragma mark - setup
- (void)setupWithInsets:(UIEdgeInsets)insets MinimumLineSpacing:(CGFloat)minimumLineSpacing MinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = insets;
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    flowLayout.itemSize = CGSizeMake(itemW,itemH);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = kWhiteColor;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:[PhotosCollectionViewCell className]];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.offset(0);
    }];
}
#pragma mark - custom method
//预览图片
- (void)previewPhotosWithIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotosCollectionViewDeletePhotoWithComplain:)]) {
       [self.delegate PhotosCollectionViewDeletePhotoWithComplain:^(BOOL isDelete) {
           if (isDelete) {
               [self deletePhotoWithIndex:index];
           }
           return;
       }];
    }
    __weak __typeof(self)weakSelf = self;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    //预览
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:index];
    imagePickerVC.maxImagesCount = maxCount;
    imagePickerVC.allowPickingOriginalPhoto = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (strongSelf) {
            weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assets];
            [weakSelf.collectionView reloadData];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(PhotosCollectionViewRefreshEndOfPhotoArray:height:)]) {
                [weakSelf.delegate PhotosCollectionViewRefreshEndOfPhotoArray:weakSelf.selectedPhotos height:weakSelf.collectionView.height];
            }
        }
    }];
    [self.viewController presentViewController:imagePickerVC animated:YES completion:nil];
}
//选择图片
- (void)choosePhotos
{
    TZImagePickerController * imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVC.selectedAssets = self.selectedAssets;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingOriginalPhoto = NO;
    [self.viewController presentViewController:imagePickerVC animated:YES completion:nil];
}
//删除
- (void)deletePhotoWithIndex:(NSInteger )index
{
    if (self.selectedPhotos.count == maxCount) {
        [self.selectedPhotos removeObjectAtIndex:index];
        [self.selectedAssets removeObjectAtIndex:index];
        [self.collectionView reloadData];
        [self updateHeight];
    }else
    {
        [self.selectedPhotos removeObjectAtIndex:index];
        [self.selectedAssets removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [self updateHeight];
    }
}
- (void)updateHeight
{
    NSInteger count = self.selectedPhotos.count / singleLineCount;
    //判断修改高度
    CGFloat height = (count + 1) * itemH + count * PCVmargin + insetTop + insetBottom ;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotosCollectionViewRefreshEndOfPhotoArray:height:)]) {
        [self.delegate PhotosCollectionViewRefreshEndOfPhotoArray:self.selectedPhotos height:height];
    }
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectedPhotos.count == maxCount) {
        return self.selectedPhotos.count;
    }else
    {
        return self.selectedPhotos.count + 1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotosCollectionViewCell className] forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:itemImageStr];
    //有图片付给按钮背景图
    if (self.selectedPhotos.count) {
        if (self.selectedPhotos.count == maxCount) {
            cell.imageView.image = self.selectedPhotos[indexPath.row];
        }else
        {
            if (indexPath.row < self.selectedPhotos.count) {
                cell.imageView.image = self.selectedPhotos[indexPath.row];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:itemImageStr];
            }
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedPhotos.count != maxCount && indexPath.row == self.selectedPhotos.count) {
        //选图片
        [self choosePhotos];
    }else
    {
        //预览
        [self previewPhotosWithIndex:indexPath.row];
    }
    
}
#pragma mark - TZImagePickerControllerDelegate
//选择完图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self.collectionView reloadData];
    //更新高度
    [self updateHeight];
}
#pragma mark - lazy
- (NSMutableArray *)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}
- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

@end
