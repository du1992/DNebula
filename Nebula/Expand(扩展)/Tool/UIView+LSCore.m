//
//  UIView+LSCore.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "UIView+LSCore.h"

@implementation UIView (LSCore)
#pragma mark - 设置部分圆角

/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 
 setNeedsLayout：告知页面需要更新，但是不会立刻开始更新。执行后会立刻调用layoutSubviews。
 layoutIfNeeded：告知页面布局立刻更新。所以一般都会和setNeedsLayout一起使用。如果希望立刻生成新的frame需要调用此方法，利用这点一般布局动画可以在更新布局后直接使用这个方法让动画生效。
 layoutSubviews：系统重写布局
 setNeedsUpdateConstraints：告知需要更新约束，但是不会立刻开始
 updateConstraintsIfNeeded：告知立刻更新约束
 updateConstraints：系统更新约束
 
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    
    [self layoutIfNeeded];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    
}
/**
 *  获取UITextView文字高度
 *
 */

- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
}
/**
 *  添加分割线
 *
 */
- (void)drawBorderLine:(UIRectEdge)edge rect:(CGRect)rect color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    [self drawBorderLine:edge rect:rect color:color lineWidth:lineWidth offset:0];
    
}
- (void)drawBorderLine:(UIRectEdge)edge rect:(CGRect)rect color:(UIColor *)color lineWidth:(CGFloat)lineWidth offset:(CGFloat)offset{
    
    if (edge == UIRectEdgeNone) {
        return;
    }
    
    BOOL top = edge & 1;
    if (top) {
        UIView *view = [UIView lineViewWithFrame:CGRectZero WithColor:color];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lineWidth);
            //            make.top.left.right.equalTo(self);
            make.left.equalTo(self).offset(offset);
            make.right.equalTo(self).offset(-offset);
            make.top.equalTo(self);
        }];
    }
    
    
    BOOL left = (edge >> 1) & 1;
    
    if (left) {
        UIView *view = [UIView lineViewWithFrame:CGRectZero WithColor:color];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lineWidth);
            //            make.top.left.bottom.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self).offset(offset);
            make.bottom.equalTo(self).offset(-offset);
        }];
        
    }
    
    BOOL bottom = (edge >> 2 ) & 1;
    if (bottom) {
        
        UIView *view = [UIView lineViewWithFrame:CGRectZero WithColor:color];
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lineWidth);
            //            make.left.bottom.right.equalTo(self);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(offset);
            make.right.equalTo(self).offset(-offset);
        }];
        
    }
    
    BOOL right = (edge >> 3) & 1;
    if (right) {
        UIView *view = [UIView lineViewWithFrame:CGRectZero WithColor:color];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lineWidth);
            //            make.top.bottom.right.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self).offset(offset);
            make.bottom.equalTo(self).offset(-offset);
        }];
        
    }
}
+ (instancetype)lineViewWithFrame:(CGRect)frame WithColor:(UIColor *)color{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    view.layer.transform = CATransform3DMakeTranslation(0, 0, 1.f);
    return view;
}
@end

