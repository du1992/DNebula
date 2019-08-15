//
//  DSliderView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/10.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DSliderView.h"



@implementation DSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
        self.backgroundColor=AppAlphaColor(0, 0, 0, 0.01);
        self.hidden=YES;
//        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tapGes];
    }
    return self;
}
-(void)setLayout{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight,kScreenWidth,100)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.bottomView.layer.cornerRadius=5;
    self.bottomView.clipsToBounds = YES;
    
    self.closeButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));;
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    JHSlider *slider = [[JHSlider alloc] initWithFrame:CGRectMake(15,40,kScreenWidth-30, 40)];
    slider.minimumValue = 0;
    slider.maximumValue = 100;

    slider.trackingLabel.frame = CGRectMake(50, 0, 50, 20);
    slider.trackingLabel.textAlignment = 1;
    slider.trackingLabelTextFormat = @"%.0f%%";
    slider.trackingLabelOffsetY = 15;
    slider.minimumTrackTintColor=RecommendedColor;
    self.slider=slider;
    
    
    [self.bottomView addSubview:slider];
    
}


/**
 *  点击按钮弹出
 */
-(void)show{
    self.hidden=NO;
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight-100,kScreenWidth,100);
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss{
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth,100);
        
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
    
}
@end
