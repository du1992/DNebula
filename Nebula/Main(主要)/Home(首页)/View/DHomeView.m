//
//  DHomeView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/22.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHomeView.h"

@implementation DHomeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.completeProportionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    

}

-(UIView*)stateView{
    if (!_stateView) {
        _stateView=[UIView new];
        _stateView.layer.cornerRadius=6;
        _stateView.clipsToBounds = YES;
        [self addSubview:_stateView];
    }
    return _stateView;
}

-(JhtHorizontalMarquee *)titleLabel{
    if (!_titleLabel) {
       _titleLabel=[[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(0, 0, 60, 20) singleScrollDuration:0.0];
        [self addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UILabel *)completeProportionLabel{
    if (!_completeProportionLabel) {
        _completeProportionLabel=[[UILabel alloc] init];
        [self addSubview:_completeProportionLabel];
        [_completeProportionLabel setFont:[UIFont systemFontOfSize:13]];
        _completeProportionLabel.textColor=WarningColor;
        _completeProportionLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _completeProportionLabel;
}

-(void)setData:(DHomeModel *)model{
    self.completeProportionLabel.hidden=YES;
    NSString *str=@"%";
    self.completeProportionLabel.text=[NSString stringWithFormat:@"%ld %@",model.completeProportion*10,str];
    
    self.model=model;
    if (model.stateType==kStateWaiting) {
//          self.stateView.backgroundColor=AppColor(41,208, 197);
        self.stateView.backgroundColor=RecommendedColor;
    }else if (model.stateType==kStateOngoing){
        self.completeProportionLabel.hidden=NO;
          self.stateView.backgroundColor=WarningColor;
    }else if (model.stateType==kStateOerdue){
       
          self.stateView.backgroundColor=AppColor(238,90, 139);
    }
    self.titleLabel.text=model.homeTitle;
    if (self.titleLabel.isPaused) {
        [self.titleLabel marqueeOfSettingWithState:MarqueeContinue_H];
    }else{
        [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    }

}

@end
