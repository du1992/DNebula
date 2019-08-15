//
//  HSFTimeDownView.m
//  TimeLabel
//
//  Created by 黄山锋 on 2018/7/16.
//  Copyright © 2018年 JustCompareThin. All rights reserved.
//

#import "HSFTimeDownView.h"

#import "HSFTimeNumberView.h"
#import "HSFTimeDownConfig.h"




@interface HSFTimeDownView()


@property (nonatomic,strong) HSFTimeDownConfig *config;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,copy)void(^change)(NSInteger);
@property(nonatomic,copy)void(^end)(void);


@property (nonatomic,strong) UILabel *dayLB;

@property(nonatomic,strong)HSFTimeNumberView *hourH;
@property(nonatomic,strong)HSFTimeNumberView *hourL;

@property(nonatomic,strong)HSFTimeNumberView *minuteH;
@property(nonatomic,strong)HSFTimeNumberView *minuteL;

@property(nonatomic,strong)HSFTimeNumberView *secondH;
@property(nonatomic,strong)HSFTimeNumberView *secondL;

@property(nonatomic)NSUInteger timeType;
@end


@implementation HSFTimeDownView
/* 初始化方法 */
-(instancetype)initWityFrame:(CGRect)frame config:(HSFTimeDownConfig *)config timeChange:(void(^)(NSInteger time))timeChange timeEnd:(void(^)(void))timeEnd{
    if (self = [super initWithFrame:frame]) {
        self.config = config;
        self.change = timeChange;
        self.end = timeEnd;
        [self setLayout];
    }
    return self;
}

//添加view
-(void)setLayout{
    
    CGFloat placeW = 20.f;
    CGFloat height = 20.f;
   
    
   
    
    
    //分钟
    self.minuteH = [[HSFTimeNumberView alloc] initWithFrame:CGRectMake(0, 0,placeW, height) maxNumber:5 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.minuteH];
    [self.minuteH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    self.minuteL = [[HSFTimeNumberView alloc] initWithFrame:CGRectMake(0, 0,placeW, height) maxNumber:9 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.minuteL];
    [self.minuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.left.mas_equalTo(self.minuteH.mas_right).offset(0);
    }];
    
    UILabel *minuteLabel = [[UILabel alloc] init];
    minuteLabel.textAlignment=NSTextAlignmentCenter;
    minuteLabel.text=Localized(@"Time2");
    minuteLabel.font=[UIFont systemFontOfSize:self.config.fontSize_placeholder];
    minuteLabel.textColor=self.config.fontColor_placeholder;
    [self addSubview:minuteLabel];
    [minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.left.mas_equalTo(self.minuteL.mas_right).offset(5);
    }];
    
    self.secondH = [[HSFTimeNumberView alloc] initWithFrame:CGRectMake(0, 0,placeW, height) maxNumber:5 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.secondH];
    [self.secondH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.left.mas_equalTo(minuteLabel.mas_right).offset(5);
    }];
    
    
    self.secondL = [[HSFTimeNumberView alloc] initWithFrame:CGRectMake(0, 0, placeW, height) maxNumber:9 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.secondL];
    [self.secondL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.left.mas_equalTo(self.secondH.mas_right).offset(0);
    }];
    
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = Localized(@"Time3");
    secondLabel.font = [UIFont systemFontOfSize:self.config.fontSize_placeholder];
    secondLabel.textColor = self.config.fontColor_placeholder;
    [self addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.left.mas_equalTo(self.secondL.mas_right).offset(5);
    }];
    
    
    
    //小时
    UILabel *hourLabel = [[UILabel alloc]init];
    hourLabel.textAlignment=NSTextAlignmentCenter;
    hourLabel.text=Localized(@"Time1");
    hourLabel.font = [UIFont systemFontOfSize:self.config.fontSize_placeholder];
    hourLabel.textColor = self.config.fontColor_placeholder;
    [self addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.minuteH.mas_left).offset(-5);
    }];
    self.hourL=[[HSFTimeNumberView alloc]initWithFrame:CGRectMake(0, 0, placeW, height) maxNumber:9 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.hourL];
    [self.hourL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW,height));
        make.right.mas_equalTo(hourLabel.mas_left).offset(-5);
    }];
  
    self.hourH = [[HSFTimeNumberView alloc]initWithFrame:CGRectMake(0, 0,placeW, height) maxNumber:5 fontSize:self.config.fontSize fontColor:self.config.fontColor bgColor:self.config.bgColor cornerRadius:self.config.cornerRadius];
    [self addSubview:self.hourH];
    [self.hourH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(placeW, height));
        make.right.mas_equalTo(self.hourL.mas_left).offset(0);
    }];
    
    //天数
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.textAlignment=NSTextAlignmentCenter;
    dayLabel.text=Localized(@"Time0");
    dayLabel.font=[UIFont systemFontOfSize:self.config.fontSize_placeholder];
    dayLabel.textColor=self.config.fontColor_placeholder;
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.hourH.mas_left).offset(-5);
    }];
    
    self.dayLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,60, height)];
    self.dayLB.textAlignment=NSTextAlignmentRight;
    self.dayLB.text=@"0";
    self.dayLB.font= AppBoldFont(self.config.fontSize);
    self.dayLB.textColor=self.config.fontColor;
    [self addSubview:self.dayLB];
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(dayLabel.mas_left).offset(-5);
    }];
    
   
    
    
   
    
    
    
 
    
    
   
}


-(void)setcurentTime:(NSInteger)curentTime timeType:(NSUInteger)timeType{
    if (curentTime<=0) {
        curentTime=1;
    }
    self.timeType=timeType;
    [self.timer invalidate];
    self.timer=nil;
   
     self.number = curentTime;
    
    [self.hourH setCurentNumber:0 timeType:self.timeType];
    [self.hourL setCurentNumber:0 timeType:self.timeType];
    [self.minuteH setCurentNumber:0 timeType:self.timeType];
    [self.minuteL setCurentNumber:0 timeType:self.timeType];
    [self.secondH setCurentNumber:0 timeType:self.timeType];
    [self.secondL setCurentNumber:0 timeType:self.timeType];
    [self setTime:curentTime];
    
    
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(numberChange) userInfo:nil repeats:YES];
}

-(void)numberChange{
    if (self.timeType) {
        self.number++;
    }else{
        self.number--;
    }
    
    if (self.number<0) {
        if (self.end) {
            self.end();
        }
        [self.timer invalidate];
        self.timer=nil;
    }else{
        if (self.change) {
            self.change(self.number);
        }
    }
   
    NSInteger curentTime=self.number;
    [self setTime:curentTime];
    
    

}

-(void)setTime:(NSInteger)curentTime{
    //天
    NSInteger day=curentTime/(3600*24);
    self.dayLB.text = [NSString stringWithFormat:@"%ld",day];
    
   
    
    //小时
//    NSInteger hour=curentTime/3600;
    NSInteger hour = (int)((curentTime-day*24*3600)/3600);
    NSString*hourString=[NSString stringWithFormat:@"%ld",(long)hour];
    
    NSInteger hourLeft;
    NSInteger hourRight;
    if (hourString.length>1) {
        hourLeft=[[hourString substringToIndex:1] intValue];
        hourRight=[[hourString substringFromIndex:1] intValue];
    }else{
        hourLeft=0;
        hourRight=hour;
    }
    if (self.hourH.curentNumber!=hourLeft) {
        [self.hourH numberChange:hourLeft timeType:self.timeType];
    }
    if (self.hourL.curentNumber!=hourRight) {
        [self.hourL numberChange:hourRight timeType:self.timeType];
    }
    
    
    //分钟
    NSInteger minute=(curentTime / 60) % 60;
    NSString*minuteString=[NSString stringWithFormat:@"%ld",(long)minute];
    
    NSInteger minuteLeft;
    NSInteger minuteRight;
    
    if (minuteString.length>1) {
        minuteLeft=[[minuteString substringToIndex:1] intValue];
        minuteRight=[[minuteString substringFromIndex:1] intValue];
    }else{
        minuteLeft=0;
        minuteRight=minute;
    }
    
    if (self.minuteH.curentNumber!=minuteLeft) {
        [self.minuteH numberChange:minuteLeft timeType:self.timeType];
    }
    if (self.minuteL.curentNumber!=minuteRight) {
        [self.minuteL numberChange:minuteRight timeType:self.timeType];
    }
    NSLog(@"分钟yy===%ld",(long)minute);
    
    //秒
    NSInteger second=curentTime % 60;
    NSString*secondString=[NSString stringWithFormat:@"%ld",(long)second];
    NSInteger secondLeft;
    NSInteger secondRight;
    if (secondString.length>1) {
        secondLeft=[[secondString substringToIndex:1] intValue];
        secondRight=[[secondString substringFromIndex:1] intValue];
    }else{
        secondLeft=0;
        secondRight=second;
    }
    
    if (self.secondH.curentNumber!=secondLeft) {
        [self.secondH numberChange:secondLeft timeType:self.timeType];
    }
    if (self.secondL.curentNumber!=secondRight) {
        [self.secondL numberChange:secondRight timeType:self.timeType];
    }
    
     NSLog(@"秒yy===%ld",(long)second);
}
-(void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer=nil;
    }
}

//获取字符串size
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize{
    if (!string) {
        return CGSizeZero;
    }
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}




@end
