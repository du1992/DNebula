//
//  UILabel+Extension.h
//  OKSheng
//
//  Created by hztuen on 17/3/20.
//  Copyright © 2017年 hztuen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 *   返回 label(字位置自己设), 参数1, 颜色; 参数2, 字体大小; 参数3,字的位置
 */
+ (UILabel *)labelWithColor:(NSString *)color AndFont:(CGFloat)font AndAlignment:(NSTextAlignment)alignment;

/**
 *   返回 label(字位置自己设), 参数1, 标题; 参数2, 颜色; 参数3, 字体大小; 参数4,字的位置
 */
+ (UILabel *)labelWithTitle:(NSString *)title AndColor:(NSString *)color AndFont:(CGFloat)font AndAlignment:(NSTextAlignment)alignment;

@end
