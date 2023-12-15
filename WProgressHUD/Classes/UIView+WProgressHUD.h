//
//  UIView+WProgressHUD.h
//  WProgressHUD
//
//  Created by winter.wd on 2017/5/3.
//  Copyright © 2017年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 系统自带动画

@interface UIView (WProgressHUD)

- (void)endLoading;

- (void)beginLoading;
- (void)beginLoadingWithTip:(NSString * _Nullable)tip;
- (void)beginNoTipLoading;

@end

#pragma mark - 自定义gif

@interface UIView (WGifHud)

/**
 无背景只显示gif -> 说明：使用时，只需在项目工程中添加"gifHud.gif"文件
 */
- (void)beginOnlyGifLoading;

/**
 带默认背景 -> 说明：使用时，只需在项目工程中添加"gifHud.gif"文件
 */
- (void)beginGifNoTipLoading;

/**
 GIF + 文字 带默认背景 -> 说明：使用时，只需在项目工程中添加"gifHud.gif"文件
 
 @param tip 提示文字
 */
- (void)beginGifLoadingWithTip:(NSString * _Nullable )tip;
@end

#pragma mark - 自定义Image 感觉这个没什么卵用

@interface UIView (WImageHud)

/**
 无背景只显示Image -> 说明：使用时，只需在项目工程中添加"imageHud.png"文件
 */
- (void)beginOnlyImageLoading;

/**
 带默认背景 -> 说明：使用时，只需在项目工程中添加"imageHud.png"文件
 */
- (void)beginImageNoTipLoading;

/**
 Image + 文字 带默认背景 -> 说明：使用时，只需在项目工程中添加"imageHud.png"文件
 
 @param tip 提示文字
 */
- (void)beginImageLoadingWithTip:(NSString * _Nullable )tip;
@end
