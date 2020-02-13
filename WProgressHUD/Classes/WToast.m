//
//  WToast.m
//  WProgressHUD
//
//  Created by winter.wd on 2017/5/3.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "WToast.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation WToast
#define WBackgoudColor [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.85];
#pragma mark - status

+ (void)showSuccess {
    [self showSuccessWithTip:nil];
}

+ (void)showSuccessWithTip:(NSString *)tip {
    [self showSuccessWithTip:tip
                delayDismiss:2
                  completion:nil];
}

+ (void)showSuccessWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [self showImageHudWithImageView:[WToast imageViewWith:@"success"]
                                tip:tip
                              delay:delay
                         completion:completion];
}

+ (void)showFailed{
    [self showFailedWithTip:nil];
}

+ (void)showFailedWithTip:(NSString *)tip {
    [self showFailedWithTip:tip
               delayDismiss:2
                 completion:nil];
}

+ (void)showFailedWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [self showImageHudWithImageView:[WToast imageViewWith:@"error"]
                                tip:tip
                              delay:delay
                         completion:completion];
}

+ (void)showInfoWithTip:(NSString *)tip {
    [self showInfoWithTip:tip
             delayDismiss:2
               completion:nil];
}

+ (void)showInfoWithTip:(NSString *)tip delayDismiss:(NSTimeInterval)delay completion:(void(^)(void))completion {
    [self showImageHudWithImageView:[WToast imageViewWith:@"info"]
                                tip:tip
                              delay:delay
                         completion:completion];
}

+ (UIImageView *)imageViewWith:(NSString *)imageName {
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [self loadImageFromResourceBundle:imageName];
    return imageview;
}

+ (void)showImageHudWithImageView:(UIImageView *)imageView tip:(NSString *)tip delay:(NSTimeInterval)delay completion:(void(^)(void))completion {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(100, 100);
    hud.margin = 13.f;
    
    NSArray *tips = [tip componentsSeparatedByString:@"\n"];
    if (tips.count > 1) {
        NSString *firstTip = [tips firstObject];
        hud.label.text = firstTip;
        NSString *string = [[tip componentsSeparatedByString:[NSString stringWithFormat:@"%@\n",firstTip]] lastObject];
        hud.detailsLabel.text = string;
        hud.detailsLabel.numberOfLines = 0;
        hud.detailsLabel.font = [UIFont systemFontOfSize:13.0];
    }
    else
        hud.label.text = tip;
    
    UIColor *contentColor = [UIColor whiteColor];
    hud.bezelView.color = WBackgoudColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = contentColor;
    imageView.tintColor = contentColor;

    CGFloat d = MAX(delay, 2);
    [hud hideAnimated:YES afterDelay:d];
    
    if (completion) {
        double delaySeconds = d + 0.1;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            // method
            if (completion) {
                completion();
            }
        });
    }
}

#pragma mark - Getting Resources from Bundle

+ (NSBundle *)getResourcesBundle {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"WToast")];
    NSURL *bundleURL = [bundle URLForResource:@"WProgressHUD" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

+ (UIImage *)loadImageFromResourceBundle:(NSString *)imageName {
    UIImage *icon = [UIImage imageNamed:imageName];
    
    CGImageRef cgref = [icon CGImage];
    CIImage *cim = [icon CIImage];
    
    if (cim == nil && cgref == NULL) {
        NSBundle *bundle = [self getResourcesBundle];
        NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
        UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return icon;
}

#pragma mark - toast only text

+ (void)showToast:(NSString *)tip {
    [self showHudTipStr:tip offsetY:0];
}

+ (void)showTopToast:(NSString *)tip {
    [self showHudTipStr:tip offsetY:-MBProgressMaxOffset];
}

+ (void)showBottomToast:(NSString *)tip{
    [self showHudTipStr:tip offsetY:MBProgressMaxOffset];
}

#pragma mark - Tip

+ (NSString *)tipFromError:(NSError *)error {
    if (error && error.userInfo) {
        NSMutableString *tipStr = [NSMutableString string];
        if ([error.userInfo objectForKey:@"msg"]) {
            id msg = [error.userInfo objectForKey:@"msg"];
            if ([msg isKindOfClass:[NSDictionary class]]) {
                NSArray *msgArray = [(NSDictionary *)msg allValues];
                NSUInteger num = msgArray.count;
                for (int i = 0; i < num; i++) {
                    NSString *msgStr = [msgArray objectAtIndex:i];
                    if (i+1 < num) {
                        [tipStr appendString:[NSString stringWithFormat:@"%@\n",msgStr]];
                    }
                    else {
                        [tipStr appendString:msgStr];
                    }
                }
            }
            else if ([msg isKindOfClass:[NSString class]]) {
                tipStr = msg;
            }
        }
        else {
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }
            else {
                NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];
                if (underlyingError) {
                    return [self tipFromError:underlyingError];
                }
                else [tipStr appendFormat:@"ErrorCode %ld",(long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

+ (BOOL)showError:(NSError *)error {
    NSString *tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr offsetY:0];
    return YES;
}

+ (void)showHudTipStr:(NSString *)tipStr {
    [self showHudTipStr:tipStr offsetY:0];
}

/**
 offsetY 0:中间; MBProgressMaxOffset:底部; -MBProgressMaxOffset:顶部
 */
+ (void)showHudTipStr:(NSString *)tipStr offsetY:(CGFloat)offsetY {
    if (tipStr && tipStr.length > 0) {
        NSTimeInterval afterDelay = [self calculateDelayTimeWith:tipStr];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *superView = [[UIView alloc] initWithFrame:keyWindow.bounds];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(superView.bounds), CGRectGetHeight(superView.bounds)-70)];
        superView.backgroundColor = [UIColor clearColor];
        subView.backgroundColor = [UIColor clearColor];
        [keyWindow addSubview:superView];
        [superView addSubview:subView];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:subView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 15.f;
        
        NSArray *tips = [tipStr componentsSeparatedByString:@"\n"];
        if (tips.count > 1) {
            NSString *firstTip = [tips firstObject];
            hud.label.text = firstTip;
            NSString *string = [[tipStr componentsSeparatedByString:[NSString stringWithFormat:@"%@\n",firstTip]] lastObject];
            hud.detailsLabel.text = string;
            hud.detailsLabel.numberOfLines = 0;
            hud.detailsLabel.font = [UIFont boldSystemFontOfSize:13.0];
        }
        else
            hud.label.text = tipStr;
        
        hud.removeFromSuperViewOnHide = YES;
        hud.offset = CGPointMake(0.f, offsetY);
        
        hud.bezelView.color = WBackgoudColor;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.contentColor = [UIColor whiteColor];
        
        [hud hideAnimated:YES afterDelay:afterDelay];
        [subView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:afterDelay];
        [superView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:afterDelay];
    }
}

+ (CGFloat)calculateDelayTimeWith:(NSString *)text {
    CGFloat delay = 1.5;
    delay += text.length / 20;
    return delay;
}

#pragma mark - NetError

- (id)handleResponseAndShowError:(id)responseJSON {
    return [self handleResponse:responseJSON autoShowError:YES];
}

- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autouShowError {
    NSError *error = nil;
    
    NSNumber *resultCode = [responseJSON valueForKey:@"code"];
    
    // 非0
    if (resultCode.integerValue != 0) {
        error = [NSError errorWithDomain:@"出错了" code:resultCode.integerValue userInfo:responseJSON];
        if (autouShowError) {
            [WToast showError:error];
        }
    }
    return error;
}
@end
