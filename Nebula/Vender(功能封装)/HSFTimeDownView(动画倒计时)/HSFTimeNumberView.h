//
//  HSFTimeNumberView.h
//  TimeLabel
//
//  Created by 黄山锋 on 2018/7/16.
//  Copyright © 2018年 JustCompareThin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFTimeNumberView : UIScrollView

@property(nonatomic,assign)NSInteger curentNumber;

- (void)setCurentNumber:(NSInteger)curentNumber timeType:(NSInteger)timeType;


/* 初始化方法 */
-(instancetype)initWithFrame:(CGRect)frame maxNumber:(NSInteger)maxNumber fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius;


-(void)numberChange:(NSInteger)curentNumber timeType:(NSInteger)timeType;
@end
