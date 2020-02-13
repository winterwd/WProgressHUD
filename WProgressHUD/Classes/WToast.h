//
//  WToast.h
//  WProgressHUD
//
//  Created by winter on 2017/5/3.
//  Copyright © 2017年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WToast : NSObject

#pragma mark - status

+ (void)showSuccess;
+ (void)showSuccessWithTip:(NSString * _Nullable)tip;
+ (void)showSuccessWithTip:(NSString * _Nullable)tip delayDismiss:(NSTimeInterval)delay completion:(void(^ _Nullable)(void))completion;

+ (void)showFailed;
+ (void)showFailedWithTip:(NSString * _Nullable)tip;
+ (void)showFailedWithTip:(NSString * _Nullable)tip delayDismiss:(NSTimeInterval)delay completion:(void(^ _Nullable)(void))completion;

+ (void)showInfoWithTip:(NSString * _Nullable)tip;
+ (void)showInfoWithTip:(NSString * _Nullable)tip delayDismiss:(NSTimeInterval)delay completion:(void(^ _Nullable)(void))completion;

#pragma mark - toast only text

+ (void)showToast:(NSString * _Nullable)tip;
+ (void)showTopToast:(NSString * _Nullable)tip;
+ (void)showBottomToast:(NSString * _Nullable)tip;

#pragma mark - Error Tip

+ (nullable NSString *)tipFromError:(NSError * _Nullable)error;
+ (void)showError:(NSError * _Nullable)error;
+ (void)showHudTipString:(NSString * _Nullable)tipString;

#pragma mark - NetError

//- (id)handleResponseAndShowError:(id)responseJSON;
//- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autouShowError;

@end
