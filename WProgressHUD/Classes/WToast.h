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
+ (void)showSuccessWithTip:(NSString *)tip;
+ (void)showSuccessWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void(^)(void))completion;

+ (void)showFailed;
+ (void)showFailedWithTip:(NSString *)tip;
+ (void)showFailedWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void(^)(void))completion;

+ (void)showInfoWithTip:(NSString *)tip;
+ (void)showInfoWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void(^)(void))completion;

#pragma mark - toast only text

+ (void)showToast:(NSString *)tip;
+ (void)showTopToast:(NSString *)tip;
+ (void)showBottomToast:(NSString *)tip;

#pragma mark - Error Tip

+ (NSString *)tipFromError:(NSError *)error;
+ (BOOL)showError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;

#pragma mark - NetError

- (id)handleResponseAndShowError:(id)responseJSON;
- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autouShowError;

@end
