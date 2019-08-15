//
//  DChoseView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DChoseView.h"
#import "DRecycleModel.h"

@implementation DChoseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
    }
    return self;
}

-(void)setLayout{
    self.alphaiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    self.alphaiView.backgroundColor =UIColorFromRGBValue_alpha((0xa1a3a6), 0.1);
   [self addSubview:self.alphaiView];
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,(iPhoneX ? kScreenHeight-440:kScreenHeight-410),kScreenWidth, 410)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(410);
//        make.left.mas_equalTo(self.mas_left).offset(0);
//        make.right.mas_equalTo(self.mas_right).offset(0);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//    }];
    
    
    //封面图片
    self.coverImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 100, 100)];
    self.coverImg.backgroundColor = [UIColor yellowColor];
    self.coverImg.layer.cornerRadius = 4;
    self.coverImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.coverImg.layer.borderWidth = 5;
    [self.coverImg.layer setMasksToBounds:YES];
    self.coverImg.contentMode=UIViewContentModeScaleAspectFill;
    self.coverImg.clipsToBounds = YES;
    [self.bottomView addSubview:self.coverImg];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    self.coverImg.userInteractionEnabled = YES;
    [self.coverImg addGestureRecognizer:tap1];
    
    self.coverLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, -20,100, 100)];
    [self.bottomView addSubview:self.coverLabel];
    self.coverLabel.text=Localized(@"Home3");
    self.coverLabel.textColor=[UIColor whiteColor];
    self.coverLabel.font=AppBoldFont(20);
    self.coverLabel.backgroundColor=AppAlphaColor(0,0,0, 0.2);
    self.coverLabel.textAlignment = NSTextAlignmentCenter;
    
    self.closeButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));;
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
   
    
    
    self.titleLabel=[[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(120,10,kScreenWidth-150,30) singleScrollDuration:0.0];
    [self.titleLabel setFont:AppBoldFont(14)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.bottomView addSubview:self.titleLabel];
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTap:)];
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:titleTap];
    
    self.titleTextView=[[UITextField alloc]init];
    [self.bottomView addSubview:self.titleTextView];
    self.titleTextView.textColor=AppColor(251,140, 52);
    self.titleTextView.font=AppBoldFont(14);
    self.titleTextView.hidden=YES;
    self.titleTextView.layer.cornerRadius=3;
    self.titleTextView.clipsToBounds = YES;
    self.titleTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleTextView.layer.borderWidth = 1.0;
    self.titleTextView.frame=CGRectMake(120,10,kScreenWidth-150-50,30);
    
    self.completeButton=[[UIButton alloc]init];
    [self.bottomView addSubview:self.completeButton];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:0];
    self.completeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.completeButton.layer.cornerRadius=3;
    self.completeButton.clipsToBounds = YES;
    self.completeButton.backgroundColor=AppColor(65, 188, 241);
    [self.completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   self.completeButton.frame=CGRectMake(kScreenWidth-120,10,50,30);
    [self.completeButton setTitle:Localized(@"Home5") forState:0];
    self.completeButton.hidden=YES;
    
    
    LRAnimationProgress *pv2 = [[LRAnimationProgress alloc] initWithFrame:CGRectMake(116,60, kScreenWidth-120, 16)];
    [self.bottomView addSubview:pv2];
    pv2.backgroundColor = [UIColor clearColor];
    pv2.layer.cornerRadius = 16/2;
    pv2.progressTintColors = @[LRColorWithRGB(0xC6FFDD),LRColorWithRGB(0xFBD786),LRColorWithRGB(0xf7797d)];
    pv2.hideStripes = YES;
    pv2.numberOfNodes = 10;
    pv2.hideAnnulus = NO;
    self.pv2=pv2;
   
    //分界线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGBValue(0xededed);
    [self.bottomView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.mas_equalTo(.5);
       make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
       make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
       make.top.mas_equalTo(self.coverImg.mas_bottom).offset(15);
    }];
    
    
    //确定按钮
    self.sureButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:0];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.bottomView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(-63);
    }];
    
    
    self.cardView=[[DCardView alloc]init];
    [self.bottomView addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.sureButton.mas_top).offset(0);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
    }];
    self.cardView.backgroundColor=[UIColor whiteColor];
    
}


//输入完成
-(void)completeButtonClicked{
    self.titleLabel.text=self.titleTextView.text;
    [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    self.titleTextView.hidden=YES;
    self.completeButton.hidden=YES;
    self.titleLabel.hidden=NO;
    [self.titleTextView resignFirstResponder];
   
    if (self.completeUpdateTata) {
        self.completeUpdateTata(self.titleLabel.text);
    }
}
//点击输入
-(void)titleTap:(UITapGestureRecognizer *)tap{
    kStateType         stateType;
   if ([self.model isKindOfClass:[DHomeModel class]]) {
        DHomeModel*homeModel    = (DHomeModel*)self.model;
        stateType               = homeModel.stateType;
    }else{
        DRecycleModel*recycleModel=(DRecycleModel*)self.model;
        stateType=recycleModel.stateType;
    }
    
    if (stateType==kStateOngoing) {
        self.titleTextView.hidden=NO;
        self.completeButton.hidden=NO;
        self.titleLabel.hidden=YES;
        [self.titleTextView becomeFirstResponder];
    }
}

-(void)refreshData{
    [self.cardArray    removeAllObjects];
    kStateType         stateType;
    UIImage            *filePath;
    NSString           *superiorID;
    if ([self.model isKindOfClass:[DHomeModel class]]) {
        DHomeModel*homeModel    = (DHomeModel*)self.model;
        stateType               = homeModel.stateType;
        filePath                =[DataManager getImage:homeModel.ico];
        self.titleLabel.text    =homeModel.homeTitle;
        self.titleTextView.text =homeModel.homeTitle;
        float completeProportion = ((float)homeModel.completeProportion/10);
        [self.pv2 setProgress:completeProportion animated:YES];
        superiorID=homeModel.downID;
    }else{
        DRecycleModel*recycleModel=(DRecycleModel*)self.model;
        stateType=recycleModel.stateType;
        filePath                =[DataManager getImage:recycleModel.ico];
        self.titleLabel.text    =recycleModel.homeTitle;
        self.titleTextView.text =recycleModel.homeTitle;
        float completeProportion = ((float)recycleModel.completeProportion/10);
        [self.pv2 setProgress:completeProportion animated:YES];
        superiorID=recycleModel.downID;
    }
    [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    
    
    
    if (filePath) {
        self.coverImg.image = filePath;
        self.coverLabel.hidden=YES;
    }else{
        self.coverImg.image = [UIImage imageNamed:@"球图标"];
         self.coverLabel.hidden=NO;
    }
    
    
   
    if (stateType==kStateOngoing) {
        //进行中
        self.titleLabel.textColor=AppColor(251,140, 52);
        self.sureButton.backgroundColor=DangerousColor;
        [self.sureButton setTitle:Localized(@"Home4") forState:0];
    }else if (stateType==kStateWaiting||stateType==kStateOerdue)
    {
        //未开始
        self.titleLabel.textColor=AppColor(41,208, 197);
        self.sureButton.backgroundColor=AppColor(41,208, 197);
        [self.sureButton setTitle:Localized(@"Home5") forState:0];
//        self.coverLabel.hidden=NO;
        
    }
    WEAKSELF
    TODBCondition *searchCondition=[TODBCondition condition:@"superiorID" equalTo:superiorID];
    [DCardModel search:searchCondition callBack:^(NSArray<NSObject *> *models) {
        [weakSelf.cardArray addObjectsFromArray:models];
        if (models.count<10) {
            DCardModel*model=[DCardModel new];
            model.cardCover=@"首页封面提示";
            [weakSelf.cardArray addObject:model];
        }
        self.cardView.imgDatas = weakSelf.cardArray;
        [self.cardView reloadData];
        
    }];
    
}



- (NSMutableArray *)cardArray{
    if (_cardArray == nil) {
        _cardArray = [NSMutableArray array];
    }
    return _cardArray;
}


-(void)showBigImage:(UITapGestureRecognizer *)tap
{
    if (self.imgBegan) {
         self.imgBegan();
    }
   
    NSLog(@"图片");
}



/**
 *  点击按钮弹出
 */
-(void)show{
    self.hidden=NO;
    self.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth, 395);
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,(iPhoneX ? kScreenHeight-425:kScreenHeight-395),kScreenWidth, 395);
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss{
    [UIView animateWithDuration: 0.35 animations: ^{
       self.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth, 395);
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
    self.titleTextView.hidden=YES;
    self.completeButton.hidden=YES;
    self.titleLabel.hidden=NO;
    [self.titleTextView resignFirstResponder];
}
@end
