//
//  UIAlertController+Extension.m
//  DiDiBeauty
//
//  Created by zhaozhe on 17/2/23.
//  Copyright © 2017年 zhaozhe. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)
+ (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles handler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block vc:(UIViewController *)vc
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < otherTitles.count; i++)
    {
        id obj = otherTitles[i];
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [(id<AlertTitleAble>)obj alertTitle];
        }
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            block(alertController, i);
        }];
        
        [alertController addAction:otherAction];
    }
    
    if (cancelTitle)
    {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }];
        
        [alertController addAction:cancleAction];
    }
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

+ (UIAlertController *)showSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles handler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block vc:(UIViewController *)vc
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < otherTitles.count; i++)
    {
        id obj = otherTitles[i];
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [(id<AlertTitleAble>)obj alertTitle];
        }
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            block(alertController, i);
        }];
        
        [alertController addAction:otherAction];
    }
    
    if (cancelTitle)
    {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }];
        
        [alertController addAction:cancleAction];
    }
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}
@end
