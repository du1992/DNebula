//
//  DPopView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DPopView.h"

#define IS_IOS_8_OR_HIGHER ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 8.0 )
/*比例*/
#define prowidht kScreenWidth / 380
@interface DPopView(){}


@end


@implementation DPopView

- (instancetype _Nullable )initWithinitModel:(DPopModel *)model{
    CGRect frame=[self getRectModel:model];
    
    if(self = [super initWithFrame:frame]){
    
        
        UIView*bgView=[UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.width.mas_equalTo(320);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
       
        
        
        /** 提示图标*/
        UIImageView*iconImageView=[UIImageView new];
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(bgView.mas_top).offset(-40);
        }];
        iconImageView.image=model.iconImage;
        iconImageView.layer.cornerRadius=40;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderColor = kColorControllerBackGround.CGColor;
        iconImageView.layer.borderWidth = 6.0;
        
        /** 提示图片*/
        UIImageView *popImageView = [[UIImageView alloc]init];
        [bgView addSubview:popImageView];
        [popImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-0);
            make.top.mas_equalTo(bgView.mas_top).offset(0.1);
            make.height.equalTo(@(150));
        }];
        popImageView.contentMode= UIViewContentModeScaleAspectFill;
        popImageView.image=model.popImage;
        popImageView.backgroundColor=[UIColor blackColor];
        popImageView.clipsToBounds = YES;
        
        /** 提示内容*/
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.textColor = RecommendedColor;
        contentLabel.numberOfLines   = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(0);
            make.right.mas_equalTo(bgView.mas_right).offset(-0);
            make.top.mas_equalTo(popImageView.mas_bottom).offset(10);
            make.height.equalTo(@110);
        }];
        contentLabel.text = model.popContent;
        
        
        /** 创建底部发送按钮bgView*/
        UIButton*buttonBgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonBgView addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBgView setTitle:model.buttonTitle forState:UIControlStateNormal];
//        [buttonBgView setBackgroundImage:[self buttonImageFromColor:RGB(0xfdfcfc)] forState:UIControlStateNormal];
       
        buttonBgView.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [buttonBgView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bgView addSubview:buttonBgView];
        [buttonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-0);
        }];
         buttonBgView.backgroundColor=model.buttonColor;
        
        
        /** 关闭按钮*/
        UIButton*shutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shutButton setImage:[UIImage imageNamed:@"个人关闭"] forState:UIControlStateNormal];
        [shutButton addTarget:self action:@selector(disappearClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:shutButton];
        [shutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
            make.top.mas_equalTo(bgView.mas_top).offset(5);
        }];
        
        
        
        
        
        
}
    return self;
}

//尺寸
-(CGRect)getRectModel:(DPopModel *)model{
    CGRect frame=CGRectMake(0, 0,kScreenWidth,330);
//    frame.size.width = ;
//    frame.size.height = 375;
    return frame;
}

#pragma mark - Button Action
-(void)sendClick:(UIButton *)button{
    //    [self removeFromSuperview];
    if(self.insideBlock){
        self.insideBlock();
    }
}

- (void)disappearClick:(UIButton *)button{
    //    [self removeFromSuperview];
    if (self.shutBlock) {
        self.shutBlock();
    }
    
}

#pragma mark - utils
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}


@end
