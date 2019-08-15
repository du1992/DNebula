//
//  DTimeTypeView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTimeTypeView.h"

@implementation DTimeTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=AppAlphaColor(0, 0, 0, 0.3);
        [self setLayout];
        self.hidden=YES;
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

-(void)setLayout{
  
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight,kScreenWidth,100)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.bottomView.layer.cornerRadius=5;
    self.bottomView.clipsToBounds = YES;
    
     CGFloat width=(kScreenWidth-30)/2-5;
   //倒计时按钮
    self.countdownButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.countdownButton setTitleColor:[UIColor whiteColor] forState:0];
    self.countdownButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.bottomView addSubview:self.countdownButton];
    [self.countdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, 45));
        make.left.mas_equalTo(self.bottomView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
    self.countdownButton.adjustsImageWhenHighlighted = NO;
    self.countdownButton.layer.cornerRadius=3;
    self.countdownButton.clipsToBounds = YES;
    [self.countdownButton setTitle:Localized(@"Card1") forState:0];
    self.countdownButton.backgroundColor=UIColorFromRGBValue(0xff4c4c);
    [self.countdownButton addTarget:self action:@selector(timeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.countdownButton.tag=0;
//    self.countdownButton.layer.borderColor = UIColorFromRGBValue(0xffbb33).CGColor;
//    self.countdownButton.layer.borderWidth = 3.0;
    
    //计时按钮
    self.timingButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timingButton setTitleColor:[UIColor whiteColor] forState:0];
    self.timingButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.bottomView addSubview:self.timingButton];
    [self.timingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, 45));
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
   self.timingButton.adjustsImageWhenHighlighted = NO;
   self.timingButton.layer.cornerRadius=3;
   self.timingButton.clipsToBounds = YES;
   [self.timingButton setTitle:Localized(@"Card2") forState:0];
    self.timingButton.backgroundColor=AppColor(65, 188, 241);
    [self.timingButton addTarget:self action:@selector(timeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.timingButton.tag=1;
//    self.timingButton.layer.borderColor = UIColorFromRGBValue(0xffbb33).CGColor;
//    self.timingButton.layer.borderWidth = 3.0;
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

-(void)timeTypeAction:(UIButton*)button{
    [self dismiss];
    if (self.updateTata) {
        self.updateTata(button.tag);
    }
    
}
@end
