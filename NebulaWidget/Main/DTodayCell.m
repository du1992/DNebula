//
//  DTodayCell.m
//  NebulaWidget
//
//  Created by DUCHENGWEN on 2019/2/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTodayCell.h"
#import "Masonry.h"

@implementation DTodayCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *cellIdentifier = NSStringFromClass([self class]);
    DTodayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setLayout];
        
    }
    return self;
}
- (void)setLayout {
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    
    //标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverView.mas_top).offset(15);
        make.left.mas_equalTo(self.coverView.mas_left).offset(15);
    }];
    
    //时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.coverView.mas_left).offset(15);
    }];
    
    //类型
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    self.typeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.typeLabel.layer.borderWidth = 0.5;
    
    
    
}


-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        [self addSubview:_coverView];
        _coverView.layer.cornerRadius=8;
        _coverView.clipsToBounds = YES;
        _coverView.backgroundColor=[UIColor blackColor];
        
    }
    return _coverView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [self.coverView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        _titleLabel.textColor=[UIColor whiteColor];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self.coverView addSubview:_timeLabel];
        _timeLabel.textColor=[UIColor whiteColor];
        _timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    }
    return _timeLabel;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        [self.coverView addSubview:_typeLabel];
        _typeLabel.textColor=[UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.layer.cornerRadius=3;
        _typeLabel.clipsToBounds = YES;
        [_typeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _typeLabel;
}



- (void)setWidgetData:(DTodayModel *)model{
   
    
    NSDate * sjDate = [NSDate date];   //手机时间
    NSInteger sjInteger = [sjDate timeIntervalSince1970];  // 手机当前时间戳
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *selectDate=[formatter dateFromString:model.chooseTime];
    NSTimeInterval selectTime = [selectDate  timeIntervalSince1970];
    long long int select = (long long int)selectTime;
    
    NSString*timeString=[self getNowTimeWithString:select :sjInteger TimeType:[model.timeType intValue]];
    self.titleLabel.text=model.cardTitle;
  
    if (timeString.length<30) {
        self.timeLabel.text=timeString;
    }
    
    if ([model.timeType isEqualToString:@"0"]) {
        self.coverView.backgroundColor=DangerousColor;
        self.typeLabel.text=Localized(@"Card1");
        self.typeLabel.backgroundColor=AppAlphaColor(260, 96, 150,0.6);
    }else{
        self.coverView.backgroundColor=DSkyColor;
        self.typeLabel.text=Localized(@"Card2");
        self.typeLabel.backgroundColor=AppAlphaColor(89, 199, 256, 0.6);
    }
    
    
}

-(NSString *)getNowTimeWithString:(NSInteger )aTimeString :(NSInteger)startTime TimeType:(NSInteger)timeType{
    
    NSTimeInterval timeInterval;
    if (timeType) {
        timeInterval= startTime-aTimeString;
    }else{
        timeInterval= aTimeString - startTime;
    }
    
    
    //    NSLog(@"%f",timeInterval);
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    
    
    
    
    NSString*timeString;
    if (days) {
        
        timeString= [NSString stringWithFormat:@"%d%@ %d%@ %d%@ %d%@", days,Localized(@"Time0"),hours,Localized(@"Time1"),minutes,Localized(@"Time2"),seconds,Localized(@"Time3")];
        return timeString;
    }
    timeString= [NSString stringWithFormat:@"%d%@ %d%@ %d%@", hours,Localized(@"Time1"),minutes,Localized(@"Time2"),seconds,Localized(@"Time3")];
    return timeString;
    
}

@end
