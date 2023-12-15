//
//  NSBundle+WProgressHUD.h
//  WProgressHUD
//
//  Created by winter on 2023/12/15.
//  Copyright © 2023 winter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (WProgressHUD)
#pragma mark - Getting Resources from Bundle
+ (NSBundle *)w_resourcesBundle;
+ (NSString *)w_localizedStringForKey:(NSString *)key;
+ (UIImage *)w_loadImageFromResourceBundle:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
