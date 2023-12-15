//
//  UIView+WProgressHUD.m
//  WProgressHUD
//
//  Created by winter.wd on 2017/5/3.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "UIView+WProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSBundle+WProgressHUD.h"

/**
 为了避免和 SDWebImage 的UIImage+GIF.h冲突，改名
 */
@implementation UIImage (WGIF)

+ (UIImage *)w_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self w_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)w_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)w_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage w_animatedGIFWithData:data];
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage w_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage w_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

@end

#pragma mark - WLoadingView

@interface WLoadingView : UIView
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)startLoadingWithTip:(NSString *)tip;
- (void)startLoadingWithTip:(NSString *)tip customView:(UIView *)customView hideBackground:(BOOL)hide;
@end

@implementation WLoadingView

- (void)startLoadingWithTip:(NSString *)tip {
    [self startLoadingWithTip:tip customView:nil hideBackground:NO];
}

- (void)startLoadingWithTip:(NSString *)tip customView:(UIView *)customView hideBackground:(BOOL)hide {
    if (nil == self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self];
        self.hud.graceTime = 0.5;
        self.hud.minShowTime = 1;
        self.hud.removeFromSuperViewOnHide = YES;
        self.hud.label.text = tip;
        self.hud.label.numberOfLines = 0;
        self.hud.animationType = MBProgressHUDAnimationFade;
        if (customView) {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.customView = customView;
            self.hud.minSize = CGSizeMake(100, 100);
            if (hide && !tip) {
                self.hud.bezelView.color = [UIColor clearColor];
                self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            }
        }
        [self addSubview:self.hud];
        [self.hud showAnimated:YES];
    }
}

- (void)stopLoading {
    if (self.hud) {
        [self.hud hideAnimated:YES];
        self.hud = nil;
    }
}
@end

#pragma mark - WProgressHUD

@interface UIView ()
@property (nonatomic, strong) WLoadingView *loadingView;
@end

@implementation UIView (WProgressHUD)

static char LoadingViewKey;

- (void)setLoadingView:(WLoadingView *)loadingView {
    [self willChangeValueForKey:@"LoadingViewKey"];
    objc_setAssociatedObject(self, &LoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingViewKey"];
}

- (WLoadingView *)loadingView {
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

- (void)beginLoadingWithTip:(NSString *)tip {
    if (!self.loadingView) {
        self.loadingView = [[WLoadingView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:self.loadingView];
    [self.loadingView startLoadingWithTip:tip];
}

- (void)beginLoadingWithTip:(NSString *)tip customView:(UIView *)customView hideBackground:(BOOL)hide {
    if (!self.loadingView) {
        self.loadingView = [[WLoadingView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:self.loadingView];
    [self.loadingView startLoadingWithTip:tip customView:customView hideBackground:hide];
}

- (void)beginLoading {
    [self beginLoadingWithTip:[NSBundle w_localizedStringForKey:@"loading"]];
}

- (void)beginNoTipLoading {
    [self beginLoadingWithTip:nil];
}

- (void)endLoading {
    if (self.loadingView) {
        [self.loadingView stopLoading];
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
}

@end

#pragma mark - 自定义gif

@implementation UIView (WGifHud)

- (void)beginOnlyGifLoading {
    UIImageView *imageView = [self gifDataView];
    [self beginLoadingWithTip:nil customView:imageView hideBackground:YES];
}

- (void)beginGifNoTipLoading {
    UIImageView *imageView = [self gifDataView];
    [self beginLoadingWithTip:nil customView:imageView hideBackground:NO];
}

- (void)beginGifLoadingWithTip:(NSString *)tip {
    UIImageView *imageView = [self gifDataView];
    [self beginLoadingWithTip:tip customView:imageView hideBackground:NO];
}

- (UIImageView *)gifDataView {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage w_animatedGIFNamed:@"gifHud"]];
    return imageview;
}
@end

#pragma mark - 自定义Image

@implementation UIView (WImageHud)

- (void)beginOnlyImageLoading {
    UIImageView *imageView = [self imageDataView];
    [self beginLoadingWithTip:nil customView:imageView hideBackground:YES];
}

- (void)beginImageNoTipLoading {
    UIImageView *imageView = [self imageDataView];
    [self beginLoadingWithTip:nil customView:imageView hideBackground:NO];
}

- (void)beginImageLoadingWithTip:(NSString *)tip {
    UIImageView *imageView = [self imageDataView];
    [self beginLoadingWithTip:tip customView:imageView hideBackground:NO];
}

- (UIImageView *)imageDataView {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage w_animatedGIFNamed:@"imageHud"]];
    return imageview;
}
@end
