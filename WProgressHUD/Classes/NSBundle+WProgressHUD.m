//
//  NSBundle+WProgressHUD.m
//  WProgressHUD
//
//  Created by winter on 2023/12/15.
//  Copyright © 2023 winter. All rights reserved.
//

#import "NSBundle+WProgressHUD.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@implementation NSBundle (WProgressHUD)

+ (NSBundle *)w_resourcesBundle {
#ifdef SWIFT_PACKAGE
    NSBundle *bundle = SWIFTPM_MODULE_BUNDLE;
#else
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"WToast")];
    NSURL *bundleURL = [bundle URLForResource:@"WProgressHUD" withExtension:@"bundle"];
#endif
    return [NSBundle bundleWithURL:bundleURL];
}

+ (NSString *)w_localizedStringForKey:(NSString *)key {
    return [self w_localizedStringForKey:key value:@""];
}

+ (NSBundle *)w_languageBundle
{
    NSString *usedLanguage = @"en";
    if ([[NSLocale preferredLanguages].firstObject hasPrefix:@"zh-Hans"]) {
        usedLanguage = @"zh-Hans";
    }
    
    return [NSBundle bundleWithPath:[[self w_resourcesBundle] pathForResource:usedLanguage ofType:@"lproj"]];
}

+ (NSString *)w_localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSBundle *bundle = [self w_languageBundle];
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}

+ (UIImage *)w_loadImageFromResourceBundle:(NSString *)imageName {
    UIImage *icon = [UIImage imageNamed:imageName];
    
    CGImageRef cgref = [icon CGImage];
    CIImage *cim = [icon CIImage];
    
    if (cim == nil && cgref == NULL) {
        NSBundle *bundle = [self w_resourcesBundle];
        NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
        UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return icon;
}

@end
