//
//  UIView+LSCore.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (LSCore)

#pragma mark - 设置部分圆角

/**
 *  设置部分圆角(相对布局)
 *
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 */
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner;
/**
 *  获取UITextView文字高度
 *
 */
- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;

/**
 *  添加分割线
 *
 */
- (void)drawBorderLine:(UIRectEdge)edge rect:(CGRect)rect color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
@end
NS_ASSUME_NONNULL_END
