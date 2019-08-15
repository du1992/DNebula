//
//  HSFTimeDownConfig.m
//  TimeLabel
//
//  Created by 黄山锋 on 2018/7/16.
//  Copyright © 2018年 JustCompareThin. All rights reserved.
//

#import "HSFTimeDownConfig.h"

@implementation HSFTimeDownConfig

//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        //初始化默认值
        self.timeType = HSFTimeType_HOUR_MINUTE_SECOND;
        self.fontColor = [UIColor whiteColor];
        self.fontSize = 15.f;
        self.bgColor = [UIColor redColor];
        self.fontSize_placeholder = 15.f;
        self.fontColor_placeholder = [UIColor darkGrayColor];
        self.fontColor_day = [UIColor redColor];
        self.cornerRadius = 5.f;
    }
    return self;
}

@end
