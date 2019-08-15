//
//  DPublishClassificationVC.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DPublishCardVC.h"
/* 动画倒计时 */
#import "HSFTimeDownView.h"
#import "HSFTimeDownConfig.h"
/* 选择时间 */
#import "WSDatePickerView.h"
#import "DTimeTypeView.h"
#import "DCoverView.h"
#import "DChooseMusicView.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

#import "DNotesVC.h"


@interface DPublishCardVC (){
    NSUserDefaults *userDefault;
    UISwipeGestureRecognizer * recognizer;
}

@property(nonatomic)NSInteger coverSelected;//封面选择

@property(nonatomic,strong)  UIImageView*bgImageView;


@property (nonatomic, strong) DTimeTypeView    *timeTypeView;
@property (nonatomic, strong) DCoverView       *coverView;
@property (nonatomic, strong) HSFTimeDownView  *timeLabel_hsf;
@property (nonatomic, strong) DChooseMusicView *chooseMusicView;

/** 标题*/
//@property (strong,nonatomic) UILabel  *navigationTitle;

@property (strong,nonatomic) JhtHorizontalMarquee  *titleLabel;
@property (strong,nonatomic) UITextField            *titleTextView;

@property (nonatomic, strong) UIView       * backView;
@property (nonatomic, strong) UIView       * commentBJView;

@property (nonatomic, strong) UIButton    * backButton;
@property (nonatomic, strong) UIButton    * likeButton;
@property (nonatomic, strong) UIButton    * shareButton;
@property (nonatomic, strong) UIButton    * commentButton;
@property (nonatomic, strong) UIButton    * applyButton;

@property (nonatomic, strong) UIButton    * completeButton;
@property (nonatomic, strong) UIButton    * musicButton;


@property (nonatomic, strong) UIButton    * timeButton;
@property (nonatomic, strong)  UIButton   * coverButton;
@property (nonatomic, strong)  UIButton   * titleButton;
@property (nonatomic, strong)  UIImageView* degreeImageView;
@property (nonatomic, strong)  NSDate     *selectDate;


@property (weak, nonatomic) id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;


@end

@implementation DPublishCardVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
     //播放音乐
    if (![DMusicPlayer sharedInstance].player) {
       [self playMusic];
    }
    [self initializeData];
    [self rotate360DegreeWithImageView];
   
   
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[DMusicPlayer sharedInstance] stopMusic];
    [self.timeLabel_hsf.timer invalidate];
    self.timeLabel_hsf.timer=nil;
    // 开启
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate;
    };
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"创建";
    [self initializeContentView];
    [self initializeTopView];
    [self initializeFunctionView];
    [self initializeBouncedView];
   
    
    [UIView animateWithDuration:1 animations:^{
        self.timeButton.alpha = 0.7;
        self.coverButton.alpha = 0.7;
        self.titleButton.alpha = 0.7;
        self.degreeImageView.alpha=0.7;
    }completion:^(BOOL finished) {
    }] ;
    
   
    userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.kevindcw.notebook.NebulaWidget"];
    
    NSString*key=StringValue(self.model.primaryID);
    if ([userDefault valueForKey:key]) {
        self.likeButton.selected =YES;
    }else{
        self.likeButton.selected =NO;
    }
    
   _restoreInteractivePopGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
   
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backButtonClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}
// 播放
-(void)playMusic{
    
    if (self.model.curIndex.length) {
        NSInteger row=[self.model.curIndex intValue];
         NSString*imgString=[NSString stringWithFormat:@"music%ld",(long)row];
         self.degreeImageView.image=ImageNamed(imgString);
        [[DMusicPlayer sharedInstance]playMusic:imgString];
    }else{
        if (self.model.cardCover.length>3) {
            [[DMusicPlayer sharedInstance]playMusic:@"music16"];
            self.degreeImageView.image=ImageNamed(@"music0");
        }else{
            NSInteger row=[self.model.cardCover intValue];
            NSString*imgString=[NSString stringWithFormat:@"music%ld",(long)row];
            self.degreeImageView.image=ImageNamed(imgString);
            [[DMusicPlayer sharedInstance]playMusic:imgString];
        }
       
    }
    
}
//设置数据
-(void)initializeData{
    if (!self.model) {
        self.model=[DCardModel crateModel];
        self.model.superiorID=self.superiorID;
        self.model.cardCover=@"0";
        self.model.timeType=0;
        self.model.cardTitle=Localized(@"Card0");
        [self.model save:nil];
        if (self.cardUpdateTata) {
            self.cardUpdateTata(self.model, YES);
        }
    }
    
    if (self.model.chooseTime.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *selectDate=[formatter dateFromString:self.model.chooseTime];
        [self nowTimeInterval:selectDate isSelect:NO TimeType:self.model.timeType];
        
    }else{
        NSUInteger curentTime=60 * 60 * 24 * 3;
        [self.timeLabel_hsf setcurentTime:curentTime timeType:self.model.timeType];
    }
   
    self.titleTextView.text =self.model.cardTitle;
    self.titleLabel.text    =self.model.cardTitle;
    self.bgImageView.image  =[self.model getCoverImage];
    [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    
    
    
}
//内容视图
-(void)initializeContentView{
    self.bgImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    self.bgImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self.view addSubview:self.bgImageView];
    
    UIView*bgView=[[UIView alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor=AppAlphaColor(0, 0, 0, 0.3);
    [self.view addSubview:bgView];
    
    
    HSFTimeDownConfig *config = [[HSFTimeDownConfig alloc]init];
    config.bgColor   = [UIColor clearColor];
    config.fontColor = AppAlphaColor(255, 255, 255, 1);
    config.fontSize = 26.f;
    config.fontColor_placeholder = AppAlphaColor(255, 255, 255, 0.8);
    config.fontSize_placeholder = 16.f;
    
    self.timeLabel_hsf = [[HSFTimeDownView alloc] initWityFrame:CGRectMake(10,kScreenHeight/2-100, kScreenWidth-20, 20) config:config timeChange:^(NSInteger time) {
        NSLog(@"hsf===%ld",(long)time);
    } timeEnd:^{
        NSLog(@"hsf===倒计时结束");
    }];
    
    [self.view addSubview:self.timeLabel_hsf];
//    self.timeLabel_hsf.center = self.view.center;
    
   
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel_hsf.mas_top).offset(-50);
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    
   
    
    self.titleTextView=[[UITextField alloc]init];
    [self.view addSubview:self.titleTextView];
    ;
    self.titleTextView.font=AppBoldFont(30);
    self.titleTextView.textColor=[UIColor whiteColor];
    self.titleTextView.hidden=YES;
    self.titleTextView.layer.cornerRadius=3;
    self.titleTextView.clipsToBounds = YES;
    self.titleTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.titleTextView.layer.borderWidth = 1.0;
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel_hsf.mas_top).offset(-50);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-90);
        make.height.mas_equalTo(63);
    }];
    
    self.completeButton=[[UIButton alloc]init];
     [self.view addSubview:self.completeButton];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:0];
    self.completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.completeButton.layer.cornerRadius=3;
    self.completeButton.clipsToBounds = YES;
    [self.completeButton setTitle:Localized(@"Home5") forState:0];
    self.completeButton.backgroundColor=AppColor(65, 188, 241);
    [self.completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel_hsf.mas_top).offset(-50);
        make.left.mas_equalTo(self.titleTextView.mas_right).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-5);
        make.height.mas_equalTo(63);
    }];
    self.completeButton.hidden=YES;
    
}
-(JhtHorizontalMarquee *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(30, 0,kScreenWidth-60,40) singleScrollDuration:0.0];
        [_titleLabel setFont:AppBoldFont(30)];
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}
//顶部视图
- (void)initializeTopView{
    self.backView = [UIView new];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(IS_iPhoneX ? 88 : 64));
    }];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.backButton];
    [self.backButton setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.frame = CGRectMake(5,(IS_iPhoneX ? 35 : 15), 50, 50);
    
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right);
        make.centerY.equalTo(self.commentButton);
        make.right.equalTo(self.view);
        make.height.equalTo(self.commentButton);
    }];
 
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.shareButton];
    [self.shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.centerY.equalTo(self.backButton);
        make.right.equalTo(self.view).offset(-12);
    }];
    
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.likeButton];
    [self.likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton setImage:[UIImage imageNamed:@"收藏图标"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"已经收藏图标"] forState:UIControlStateSelected];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.centerY.equalTo(self.backButton);
        make.right.equalTo(self.shareButton.mas_left).offset(-20);
    }];
   
}
-(void)likeButtonClicked{
    NSString*key=StringValue(self.model.primaryID);
    if (!self.model.chooseTime.length) {
        [EasyTextView showInfoText:Localized(@"Card6")  config:^EasyTextConfig *{
            return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
        }];
        return;
    }
    
    NSArray*array= [userDefault valueForKey:@"modelArray"];
    NSMutableArray* modelArray=[NSMutableArray array];
    [modelArray addObjectsFromArray:array];
    if (self.likeButton.selected) {
        self.likeButton.selected=NO;
         [userDefault setValue:nil forKey:key];
         [modelArray removeObject:key];
         [userDefault setValue:modelArray forKey:@"modelArray"];
    }else{
        // 存
        if (array.count>10) {
            [EasyTextView showInfoText:Localized(@"Card7")  config:^EasyTextConfig *{
                return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
            }];
            return;
        }


        NSString*timeType=StringValue(self.model.timeType);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.model.chooseTime    forKey:@"chooseTime"];
        [dic setObject:self.model.cardTitle     forKey:@"cardTitle"];
        [dic setObject:timeType                 forKey:@"timeType"];
        [userDefault setValue:dic forKey:key];
        self.likeButton.selected=YES;
        
        [modelArray  addObject:key];
        [userDefault setValue:modelArray forKey:@"modelArray"];
    }
    
    
}
//分享
-(void)shareButtonClicked{
    UIImage *imageToShare = [self getViewImg];
   
    NSArray *itemArr = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems: itemArr applicationActivities:nil];
    [self presentViewController: activityVC animated:YES completion:nil];
}
-(UIImage*)getViewImg{
    CGSize s =self.view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    return [UIImage imageWithData: imageData];
    
}
//弹框视图
-(void)initializeBouncedView{
    self.timeTypeView=[[DTimeTypeView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    [self.view addSubview:self.timeTypeView];
    
    self.chooseMusicView=[[DChooseMusicView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    [self.view addSubview:self.chooseMusicView];
    self.chooseMusicView.listArray=[DMusicPlayer sharedInstance].listArray;
    
    self.coverView=[[DCoverView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    [self.view addSubview:self.coverView];
    
    
    
    
    NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<11; i++) {
        DCardModel*model=[DCardModel new];
        model.cardCover=[NSString stringWithFormat:@"%d",i];
        [array addObject:model];
    }
    DCardModel*model=[DCardModel new];
    model.cardCover=@"首页封面提示";
    [array addObject:model];
    
    self.coverView.cardView.imgDatas = array;
    [self.coverView.cardView reloadData];
}
//功能视图
-(void)initializeFunctionView{
  
    
    /** 设置标题*/
    UIButton*titleButton =[self getButtonImage:@"标题"];
    [titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-45);
    }];
    self.titleButton=titleButton;
    
    /**设置封面*/
    UIButton*coverButton = [self getButtonImage:@"封面"];
    [coverButton addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.bottom.mas_equalTo(titleButton.mas_top).offset(-20);
    }];
    self.coverButton=coverButton;
    
    /**设置时间*/
    UIButton*timeButton =[self getButtonImage:@"时间"];
    [timeButton addTarget:self action:@selector(typeClick) forControlEvents:UIControlEventTouchUpInside];
    [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.bottom.mas_equalTo(coverButton.mas_top).offset(-20);
    }];
    self.timeButton=timeButton;
    self.timeButton.layer.borderWidth= 2;
    if (self.model.timeType) {
        self.timeButton.layer.borderColor=AppColor(65, 188, 241).CGColor;
    }else{
        self.timeButton.layer.borderColor=DangerousColor.CGColor;
    }
    

    //音乐🎵
    UIImageView*imgView=[[UIImageView alloc]initWithImage:ImageNamed(@"music0")];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-45);
    }];
    imgView.layer.borderColor=[UIColor whiteColor].CGColor;
    imgView.layer.borderWidth= 0.5;
    imgView.layer.cornerRadius=25;
    imgView.clipsToBounds = YES;
    self.degreeImageView=imgView;
    
    UIButton*musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicButton addTarget:self action:@selector(musicClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:musicButton];
    [musicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-45);
    }];
    self.musicButton=musicButton;
    
    //管理笔记
    [self getnotesView];
}
-(void)getnotesView{
    
    UIView*notesView = [[UIView alloc]init];
    [self.view addSubview:notesView];
    notesView.backgroundColor=AppAlphaColor(0, 0, 0, 0.6);
    notesView.layer.cornerRadius=4;
    notesView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [notesView addGestureRecognizer:tap];
    
    
    [notesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.bottom.mas_equalTo(self.musicButton.mas_top).offset(-10);
    }];
    UIImageView*imgView=[[UIImageView alloc]initWithImage:ImageNamed(@"笔记本")];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [notesView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(notesView.mas_left).offset(5);
        make.centerY.mas_equalTo(notesView.mas_centerY);
    }];
    
    UILabel*titeLabel=[[UILabel alloc]init];
    [notesView addSubview:titeLabel];
    [titeLabel setFont:AppFont(13)];
    titeLabel.textColor=[UIColor whiteColor];
    [titeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(5);
        make.right.mas_equalTo(notesView.mas_right).offset(-6);
        make.centerY.mas_equalTo(notesView.mas_centerY);
    }];
    titeLabel.text=Localized(@"Card5");
    
}
//笔记列表
- (void)singleTap:(UITapGestureRecognizer *)tap {
    DNotesVC*VC=[DNotesVC new];
    VC.superiorID=StringValue(self.model.primaryID);
    VC.cardTitle =self.model.cardTitle;
    VC.cardModel =self.model;
    [self.navigationController pushViewController:VC animated:YES];
}
//设置标题
-(void)titleClick{
    self.titleTextView.hidden=NO;
    self.completeButton.hidden=NO;
    self.titleLabel.hidden=YES;
    [self.titleTextView becomeFirstResponder];
    
}
-(void)completeButtonClicked{
    self.titleLabel.text=self.titleTextView.text;
    [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    self.titleTextView.hidden=YES;
    self.completeButton.hidden=YES;
    self.titleLabel.hidden=NO;
    [self.titleTextView resignFirstResponder];
    self.model.cardTitle=self.titleLabel.text;
    [self.model save:nil];
    if (self.cardUpdateTata) {
        self.cardUpdateTata(self.model, NO);
    }
    if (self.likeButton.selected ==YES) {
       [self updatDataLocal];
    }
   
}
//设置封面
-(void)coverClick{
    [self.coverView show];
    WEAKSELF
    self.coverView.cardView.updateTata = ^(DCardModel * _Nonnull model, NSInteger curIndex) {
        if ([model.cardCover isEqualToString:@"首页封面提示"]) {
            [weakSelf showAssetPickerController];
        }else{
            weakSelf.model.cardCover=model.cardCover;
            [weakSelf.model save:nil];
            weakSelf.bgImageView.image =[weakSelf.model getCoverImage];
        }
        [weakSelf playMusic];
        if (weakSelf.cardUpdateTata) {
            weakSelf.cardUpdateTata(weakSelf.model, NO);
        }
    };
}
- (void)showAssetPickerController{
    
    WEAKSELF
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo=NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage  *photo=photos[0];
        weakSelf.model.cardCover=[DataManager saveImage:photo];
        [weakSelf.model save:nil];
        weakSelf.bgImageView.image =photo;
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//设置时间
-(void)timeClick:(NSInteger)TimeType{
    WEAKSELF
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        if (![weakSelf nowTimeInterval:selectDate isSelect:YES TimeType:TimeType]) {
          
            weakSelf.model.chooseTime=dateString;
            weakSelf.model.timeType=TimeType;
            [weakSelf.model save:nil];
            if (weakSelf.cardUpdateTata) {
                weakSelf.cardUpdateTata(self.model, NO);
            }
            
            if (weakSelf.model.timeType) {
                self.timeButton.layer.borderColor=AppColor(65, 188, 241).CGColor;
            }else{
                self.timeButton.layer.borderColor=DangerousColor.CGColor;
            }
          
            [weakSelf updatDataLocal];

        }
    }];
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    if (TimeType) {
        datepicker.dateLabelColor = DSkyColor;//年-月-日-时-分 颜色
        datepicker.doneButtonColor = DSkyColor;//确定按钮的颜色
        datepicker.maxLimitDate=[NSDate date];
    }else{
        datepicker.dateLabelColor = DangerousColor;//年-月-日-时-分 颜色
        datepicker.doneButtonColor = DangerousColor;//确定按钮的颜色
        datepicker.minLimitDate=[NSDate date];
    }
    
    [datepicker show];
}
-(BOOL)nowTimeInterval:(NSDate *)selectDate isSelect:(BOOL)isSelect TimeType:(NSInteger)timeType{
    NSDate *datenow = [NSDate date];
    NSTimeInterval nowTime = [datenow timeIntervalSince1970];
    long long int nowDate = (long long int)nowTime;
    
    NSTimeInterval selectTime = [selectDate  timeIntervalSince1970];
    long long int select = (long long int)selectTime;
    
    
    NSUInteger date;
    if (self.model.timeType) {
        date = nowDate - select;
        
    }else{
        date = select-nowDate;
    }
    if (!timeType&&nowTime>selectTime) {
        if (isSelect) {
            [self timeClick:timeType];
        }
        
        [EasyTextView showInfoText:[NSString stringWithFormat:@"【%@】%@",Localized(@"Card1"),Localized(@"Card3")] config:^EasyTextConfig *{
            return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
        }];
        
         return YES;
    }
    if (timeType&&selectTime>nowTime) {
        if (isSelect) {
             [self timeClick:timeType];
        }
        
        [EasyTextView showInfoText:[NSString stringWithFormat:@"【%@】%@",Localized(@"Card2"),Localized(@"Card4")]  config:^EasyTextConfig *{
            return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
        }];
       
       
        return YES;
    }
    
    [self.timeLabel_hsf setcurentTime:date timeType:timeType];
    
    return NO;
}
//设置类型
-(void)typeClick{
    WEAKSELF
    [self.timeTypeView show];
    self.timeTypeView.updateTata = ^(NSUInteger TimeType) {
       [weakSelf  timeClick:TimeType];
    };
    
}
//音乐
-(void)musicClick{
    NSInteger row;
    if (self.model.curIndex.length) {
         row=[self.model.curIndex intValue];
        
    }else{
        if (self.model.cardCover.length>3) {
            row=0;
        }else{
             row=[self.model.cardCover intValue];
        }
        
    }
    
    self.chooseMusicView.curIndex=row;
    [self.chooseMusicView.tableView reloadData];
    [self.chooseMusicView show];
     WEAKSELF
     self.chooseMusicView.chooseMusicUpdateTata = ^(NSInteger curIndex) {
         weakSelf.model.curIndex=StringValue(curIndex);
         [weakSelf.model save:nil];
         NSString*imgString=[NSString stringWithFormat:@"music%ld",(long)curIndex];
         weakSelf.degreeImageView.image=ImageNamed(imgString);
         
         if (weakSelf.cardUpdateTata) {
             weakSelf.cardUpdateTata(weakSelf.model, NO);
         }
    };
}

#pragma mark -旋转动画
-(UIImageView *)rotate360DegreeWithImageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 1.6;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,self.degreeImageView.frame.size.width, self.degreeImageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [self.degreeImageView.image drawInRect:CGRectMake(1,1,self.degreeImageView.frame.size.width-2,self.degreeImageView.frame.size.height-2)];
    self.degreeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.degreeImageView.layer addAnimation:animation forKey:nil];
    return self.degreeImageView;
}


-(UIButton*)getButtonImage:(NSString*)image{
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.backgroundColor=AppAlphaColor(0, 0, 0, 0.6);
    button.layer.cornerRadius=25;
    button.clipsToBounds = YES;
    button.layer.borderWidth= 1;
    button.layer.borderColor=[UIColor whiteColor].CGColor;
    [button setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    [self.view addSubview:button];
    return button;
}


- (void)backButtonClicked{
//    if (![DataManager getDataKey:KAPPComments]) {
//        NSString* commentsNumber=[DataManager getDataKey:KCommentsNumber];
//        if ([commentsNumber intValue]>15) {
//            [self goToAppStore];
//        }else{
//            NSInteger number=[commentsNumber intValue];
//            number++;
//            [DataManager setDataKey:KCommentsNumber data:[NSString stringWithFormat:@"%ld",(long)number]];
//             [self delayReturn];
//        }
//        
//    }else{
        
        [self delayReturn];
        
        
//    }
    
   
}
-(void)delayReturn{
    WEAKSELF
    EasyLoadingView *LoadingV =[EasyLoadingView showLoadingText:@"" imageName:@"保存中" config:^EasyLoadingConfig *{
        static int a = 0 ;
        int type = ++a%2 ? LoadingShowTypeImageUpturnLeft : LoadingShowTypeImageUpturn ;
        return [EasyLoadingConfig shared].setLoadingType(type).setBgColor([UIColor blackColor]).setTintColor([UIColor whiteColor]).setSuperReceiveEvent(NO);
    }];
    
    dispatch_queue_after_S(0.5, ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [EasyLoadingView hidenLoading:LoadingV];
        if (weakSelf.cardUpdateTata) {
            weakSelf.cardUpdateTata(self.model, NO);
        }
        
    });
    
}

//评论
-(void)goToAppStore{
    WEAKSELF
    [DBusiness evaluationPop:Localized(@"Popout5") failure:^(NSError * _Nonnull error) {
         if (weakSelf.cardUpdateTata) {
            weakSelf.cardUpdateTata(self.model, NO);
         }
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

}


-(void)updatDataLocal{
    NSString*key=StringValue(self.model.primaryID);
    NSString*timeType=StringValue(self.model.timeType);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.model.chooseTime    forKey:@"chooseTime"];
    [dic setObject:self.model.cardTitle     forKey:@"cardTitle"];
    [dic setObject:timeType                 forKey:@"timeType"];
    [userDefault setValue:dic forKey:key];
}


#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
@end
