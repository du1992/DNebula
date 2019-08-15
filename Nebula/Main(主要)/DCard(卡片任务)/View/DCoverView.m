//
//  DCoverView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/26.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DCoverView.h"

@implementation DCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=AppAlphaColor(0, 0, 0, 0.3);
        [self setLayout];
        self.hidden=YES;
//        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tapGes];
    }
    return self;
}

-(void)setLayout{
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight,kScreenWidth,200)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.bottomView.userInteractionEnabled=YES;
    self.bottomView.layer.cornerRadius=5;
    self.bottomView.clipsToBounds = YES;
    
    self.cardView=[[DCardView alloc]init];
    [self.bottomView addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(0);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    self.cardView.backgroundColor=[UIColor whiteColor];
    self.cardView.userInteractionEnabled=YES;
    self.bottomView.layer.cornerRadius=5;
    self.bottomView.clipsToBounds = YES;
    UIButton*button=[[UIButton alloc]init];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
   
}

/**
 *  点击按钮弹出
 */
-(void)show{
    self.hidden=NO;
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight-200,kScreenWidth,200);
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss{
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth,200);
        
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
    
}

-(void)timeTypeAction:(UIButton*)button{
    [self dismiss];
//    if (self.updateTata) {
//        self.updateTata(button.tag);
//    }
    
}
@end
