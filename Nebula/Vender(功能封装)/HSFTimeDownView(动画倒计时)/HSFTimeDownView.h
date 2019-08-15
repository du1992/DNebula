//
//  HSFTimeDownView.h
//  TimeLabel
//
//  Created by 黄山锋 on 2018/7/16.
//  Copyright © 2018年 JustCompareThin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HSFTimeDownConfig;

@interface HSFTimeDownView : UIView

-(instancetype)initWityFrame:(CGRect)frame config:(HSFTimeDownConfig *)config timeChange:(void(^)(NSInteger time))timeChange timeEnd:(void(^)(void))timeEnd;

-(void)setcurentTime:(NSInteger)curentTime timeType:(NSUInteger)timeType;

@property(nonatomic,strong)NSTimer *timer;

@end
