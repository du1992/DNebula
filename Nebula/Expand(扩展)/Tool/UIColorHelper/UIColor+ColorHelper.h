//
//  UIColor+ColorHelper.h
//  BaseFramework
//
//  Created by hztuen on 17/3/3.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorHelper)

//UIColor 转16进制字符串
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//UIColor 转UIImage
+ (UIImage*) imageWithColor: (UIColor*) color;

@end
