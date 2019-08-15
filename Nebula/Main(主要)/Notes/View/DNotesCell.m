//
//  DNotesCell.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DNotesCell.h"

@implementation DNotesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       self.backgroundColor=[UIColor whiteColor];
       [self setLayout];
        [self drawBorderLine:UIRectEdgeBottom rect:self.bounds  color:UIColorFromRGBValue(0xF4F4F4) lineWidth:5];
        
    }
    return self;
}

-(DNotesImageView1 *)notesImageView1{
    if (!_notesImageView1) {
        WEAKSELF
        _notesImageView1 = [[DNotesImageView1 alloc]init];
        [self addSubview:_notesImageView1];
        _notesImageView1.singleTapGestureBlock = ^(NSInteger tag, UIView * _Nonnull view) {
            if ( weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock(tag, view);
            }
        };
       
    }
    return _notesImageView1;
}
-(DNotesImageView2 *)notesImageView2{
    if (!_notesImageView2) {
        WEAKSELF
        _notesImageView2 = [[DNotesImageView2 alloc]init];
        [self addSubview:_notesImageView2];
        _notesImageView2.singleTapGestureBlock = ^(NSInteger tag, UIView * _Nonnull view) {
            if ( weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock(tag, view);
            }
        };
        
    }
    return _notesImageView2;
}
-(DNotesImageView3 *)notesImageView3{
    if (!_notesImageView3) {
        WEAKSELF
        _notesImageView3 = [[DNotesImageView3 alloc]init];
        [self addSubview:_notesImageView3];
        _notesImageView3.singleTapGestureBlock = ^(NSInteger tag, UIView * _Nonnull view) {
            if ( weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock(tag, view);
            }
        };
        
    }
    return _notesImageView3;
}
-(DNotesImageView4 *)notesImageView4{
    if (!_notesImageView4) {
        WEAKSELF
        _notesImageView4 = [[DNotesImageView4 alloc]init];
        [self addSubview:_notesImageView4];
        _notesImageView4.singleTapGestureBlock = ^(NSInteger tag, UIView * _Nonnull view) {
            if ( weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock(tag, view);
            }
        };
        
    }
    return _notesImageView4;
}

-(UILabel *)allLabel{
    if (!_allLabel) {
        _allLabel = [[UILabel alloc]init];
        [self addSubview:_allLabel];
        _allLabel.font = [UIFont systemFontOfSize:14];
        _allLabel.textColor = AppAlphaColor(87, 164, 254, 1);
        
    }
    return _allLabel;
}
-(TCTextView *)textView{
    if (!_textView) {
        _textView = [[TCTextView alloc]init];
        [self addSubview:_textView];
        _textView.textColor = UIColorFromRGBValue(0x333333);
        _textView.placeholdLabel.textColor = UIColorFromRGBValue(0xE2E2E2);
        _textView.scrollEnabled = NO;
        _textView.font = AppFont(14);
        _textView.userInteractionEnabled=NO;
    }
    return _textView;
}
-(UILabel *)labelYear{
    if (!_labelYear) {
        _labelYear = [[UILabel alloc]init];
        [self addSubview:_labelYear];
        _labelYear.font = [UIFont systemFontOfSize:14];
        _labelYear.textColor = RecommendedColor;
    }
    return _labelYear;
}
-(UILabel *)labelMinutes{
    if (!_labelMinutes) {
        _labelMinutes = [[UILabel alloc]init];
        [self addSubview:_labelMinutes];
        _labelMinutes.font = [UIFont systemFontOfSize:14];
        _labelMinutes.textColor = RecommendedColor;
    }
    return _labelMinutes;
}
-(UILabel *)labelMonthAndDay{
    if (!_labelMonthAndDay) {
        _labelMonthAndDay = [[UILabel alloc]init];
        [self addSubview:_labelMonthAndDay];
        _labelMonthAndDay.textAlignment = NSTextAlignmentLeft;
        _labelMonthAndDay.font = [UIFont systemFontOfSize:25];
        _labelMonthAndDay.textColor = RecommendedColor;
        
    }
    return _labelMonthAndDay;
}
-(void)setLayout{

    [self.notesImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
         make.height.mas_equalTo(190);
    }];
    
    
    [self.notesImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.height.mas_equalTo(NotesImageWIDTH);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    
    [self.notesImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.height.mas_equalTo(215);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    [self.notesImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.height.mas_equalTo(NotesImageHeight4);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    
    
    //月份
    [self.labelMonthAndDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    //年份
    [self.labelYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    //分钟
    [self.labelMinutes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(self.labelYear.mas_right).offset(5);
    }];
    
  
   

//    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.textView.mas_bottom).offset(0);
//        make.left.mas_equalTo(self.mas_left).offset(18);
//    }];
    
}
-(void)setData:(DNotesModel *)model{
   
    self.notesImageView1.hidden=YES;
    self.notesImageView2.hidden=YES;
    self.notesImageView3.hidden=YES;
    self.notesImageView4.hidden=YES;
  
//    self.textView.frame=CGRectMake(0,0, kScreenWidth , model.textViewHeight);
    //文字信息
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.labelMonthAndDay.mas_top).offset(-5);
        make.height.mas_equalTo(model.textViewHeight);
    }];
    
    
    
    BOOL isAll=NO;
    NSDate *photoDate = [DataManager NSStringDateToNSDate:model.createTime formatter:@"yyyy-MM-dd HH:mm"];
    NSInteger textHeight=model.textHeight;
    if (textHeight>100) {
        textHeight=100;
        isAll=YES;
    }
    self.textView.text=model.notesTextContent;
    self.textView.frame=CGRectMake(15,40, kScreenWidth - 15 * 2, textHeight);
    
    
    
    self.labelMonthAndDay.attributedText =[self dateStrFormStr:[DataManager NSDateToNSString:photoDate formatter:@"MMdd"]];
    self.labelYear.text = [DataManager NSDateToNSString:photoDate formatter:@"yyyy"];
    self.labelMinutes.text = [DataManager NSDateToNSString:photoDate formatter:@"HH:mm"];
    
//    if (isAll) {
//       _allLabel.text=@"全文>";
//    }else{
//       _allLabel.text=@"查看详情>";
//    }
    if (model.photoList.count==1) {
        self.notesImageView1.hidden=NO;
        [self.notesImageView1 setData:model.photoList];
    }else if (model.photoList.count==2){
        self.notesImageView2.hidden=NO;
        [self.notesImageView2 setData:model.photoList];
    }else if (model.photoList.count==3){
        self.notesImageView3.hidden=NO;
        [self.notesImageView3 setData:model.photoList];
    }else if (model.photoList.count>3){
        self.notesImageView4.hidden=NO;
        [self.notesImageView4 setData:model.photoList];
    }
    
}
- (NSAttributedString *)dateStrFormStr:(NSString *)dateStr
{
    NSString *dayStr = [dateStr substringWithRange:NSMakeRange(0, 2)];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(2, 2)];
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:dayStr attributes:@{
                                                                                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:28]}];
    [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:monthStr attributes:@{
                                                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}]];
    return resultStr;
}


@end












@implementation DNotesHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setLayout];
    }
    return self;
}

- (void)setLayout {
    
    [self.bjImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@200);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@200);
    }];
    [self.introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(67);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjImageView.mas_bottom).offset(-25);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@60);
    }];
    
    
    
    
    HSFTimeDownConfig *config = [[HSFTimeDownConfig alloc]init];
    config.bgColor   = [UIColor clearColor];
    config.fontColor = [UIColor blackColor];
    config.fontSize = 18.f;
    config.fontColor_placeholder = [UIColor blackColor];
    config.fontSize_placeholder = 16.f;
    self.timeLabel_hsf = [[HSFTimeDownView alloc] initWityFrame:CGRectMake(0,20, kScreenWidth-35, 20) config:config timeChange:^(NSInteger time) {
        NSLog(@"hsf===%ld",(long)time);
    } timeEnd:^{
        NSLog(@"hsf===倒计时结束");
    }];
    
    [self.shadowView  addSubview:self.timeLabel_hsf];
    
//    [self.timeLabel_hsf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(67);
//        make.left.mas_equalTo(self.mas_left).offset(50);
//        make.right.mas_equalTo(self.mas_right).offset(-50);
//    }];
    
   
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.shadowView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
}

-(UIImageView*)bjImageView{
    if (!_bjImageView) {
        _bjImageView=[UIImageView new];
        _bjImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bjImageView.clipsToBounds = YES;
        [self addSubview:_bjImageView];
    }
    return _bjImageView;
}

-(UIView*)bgView{
    if (!_bgView) {
        _bgView=[UIView new];
        _bgView.backgroundColor= AppAlphaColor(0,0,0, 0.4);
        [self addSubview:_bgView];
    }
    return _bgView;
}

-(UIView*)shadowView{
    if (!_shadowView) {
        _shadowView=[UIView new];
        [self addSubview:_shadowView];
        _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 3);
        _shadowView.layer.shadowOpacity = 0.3;
        _shadowView.layer.shadowRadius = 4.0;
        _shadowView.layer.cornerRadius = 10.0;
        _shadowView.clipsToBounds = NO;
        _shadowView.backgroundColor=[UIColor whiteColor];
    }
    return _shadowView;
}


-(UILabel *)introduce{
    if (!_introduce) {
        _introduce = [[UILabel alloc]init];
        [self addSubview:_introduce];
        _introduce.textColor=[UIColor whiteColor];
        _introduce.font = [UIFont systemFontOfSize:14];
        _introduce.numberOfLines = 0;
        _introduce.textAlignment = NSTextAlignmentCenter;
     }
    return _introduce;
}
-(TCTextView *)textView{
    if (!_textView) {
        _textView = [[TCTextView alloc]init];
        [self addSubview:_textView];
        _textView.textColor = UIColorFromRGBValue(0x333333);
        _textView.placeholdLabel.textColor = UIColorFromRGBValue(0xE2E2E2);
        _textView.scrollEnabled = NO;
        _textView.font = AppFont(14);
        _textView.userInteractionEnabled=NO;
    }
    return _textView;
}





@end


