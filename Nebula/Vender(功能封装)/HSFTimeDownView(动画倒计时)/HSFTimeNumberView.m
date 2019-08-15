//
//  HSFTimeNumberView.m
//  TimeLabel
//
//  Created by 黄山锋 on 2018/7/16.
//  Copyright © 2018年 JustCompareThin. All rights reserved.
//

#import "HSFTimeNumberView.h"

@interface HSFTimeNumberView()

@property(nonatomic,strong)UILabel *label0;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,assign)NSInteger maxNumber;

@property (nonatomic,strong) UIColor *bgColor;//背景颜色
@property (nonatomic,assign) CGFloat fontSize;//字体大小
@property (nonatomic,strong) UIColor *fontColor;//字体颜色
@property (nonatomic,assign) CGFloat cornerRadius;//圆角


@end

@implementation HSFTimeNumberView
/* 初始化方法 */
-(instancetype)initWithFrame:(CGRect)frame maxNumber:(NSInteger)maxNumber fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius{
    if (self = [super initWithFrame:frame]) {
        //初始化赋值
        self.maxNumber = maxNumber;
        self.fontSize = fontSize;
        self.fontColor = fontColor;
        self.bgColor = bgColor;
        self.cornerRadius = cornerRadius;
        
        //frame
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        
        self.contentSize = CGSizeMake(w, h*2);
        self.contentOffset = CGPointMake(0, h);
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.backgroundColor = self.bgColor;
        self.layer.cornerRadius = self.cornerRadius;
        self.scrollEnabled = NO;
        
        self.label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, h, w, h)];
        self.label0.textAlignment = NSTextAlignmentCenter;
        self.label0.font =AppBoldFont(self.fontSize);
        self.label0.textColor = self.fontColor;
        [self addSubview:self.label0];
        self.label0.text = @"0";
        
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont systemFontOfSize:self.fontSize];
        self.label1.textColor = self.fontColor;
        [self addSubview:self.label1];
        self.label1.text = @"0";
    }
    return self;
}

- (void)setCurentNumber:(NSInteger)curentNumber timeType:(NSInteger)timeType{
    
    _curentNumber = curentNumber;
    
    if (curentNumber <= self.maxNumber && curentNumber >= 0 ) {
        self.label0.text=[NSString stringWithFormat:@"%ld",(long)curentNumber];
        NSInteger next;
        if (timeType) {
            next=curentNumber+1;
        }else{
            next=curentNumber-1;
        }
        if (next<0) {
            next=self.maxNumber;
        }
        self.label1.text=[NSString stringWithFormat:@"%ld",(long)next];
    }
}

-(void)numberChange:(NSInteger)curentNumber timeType:(NSInteger)timeType{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset=CGPointMake(0, 0);
    } completion:^(BOOL finished) {
       

//        if (self.curentNumber<0) {
            self.curentNumber=curentNumber;
//        }
        
        
        
        self.label0.text=[NSString stringWithFormat:@"%ld",(long)curentNumber];
        self.contentOffset=CGPointMake(0, self.frame.size.height);
        
        NSInteger next;
        if (timeType) {
            next=curentNumber+1;
        }else{
            next=curentNumber-1;
        }
        
        if (next>9) {
            next=0;
        }
        self.label1.text=[NSString stringWithFormat:@"%ld",(long)next];
    }];
}

@end
