//
//  DHomeViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHomeViewController.h"
#import "DHomeModel.h"
#import "DSphereView.h"
#import "DHomeView.h"
#import "DChoseView.h"
#import "DCardModel.h"
#import "DPublishCardVC.h"
#import "DPersonalMenuVC.h"
#import "DNavigationController.h"
#import "DRecycleModel.h"
#import "DHasCreatedVC.h"
#import "DSliderView.h"
#import "DInstructionsVC.h"
@interface DHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
     CGPoint          center;
 
}


@property(nonatomic,strong)  UIButton          *suspensionButton;
@property (nonatomic, strong) NSMutableArray   *homeViewArray;
@property (nonatomic, strong) DSphereView      *sphereView;
@property (nonatomic, strong) UIScrollView     *backgroundScrollView;
@property (nonatomic, strong) DChoseView       *choseView;
@property (nonatomic, strong) YLImageView      *bgImageView;
@property (nonatomic, strong) DHomeView        *selectedHomeView;
@property (nonatomic, strong) DSliderView      *sliderView;
@property (nonatomic, strong) UIView           *backgroundView;
@property (nonatomic, assign) NSInteger        currentIndex;
@property (nonatomic, assign) NSInteger        transparency;


@end

@implementation DHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeViewArray=[NSMutableArray array];
    [self addBarButton];
    [self initializeBackgroundScrollView];
    [self initializeRefresh:YES];
    [self initializeSliderView];
    [DBusiness yp_checkoutUpdateAppVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPushNebulaWidget:) name:@"NebulaWidget" object:nil];
    
    
    if (![DataManager getDataKey:kInstructions]) {
        [DataManager setDataKey:kInstructions];
        DInstructionsVC*VC=[[DInstructionsVC alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
    }
    
}
-(void)onPushNebulaWidget:(NSNotification *)notification{
    NSDictionary *pushObj = notification.object;
    NSString *openNewsID = pushObj[@"openNewsID"];
    
    WEAKSELF
    TODBCondition *searchCondition=[TODBCondition condition:@"primaryID" equalTo:openNewsID];
    [DCardModel search:searchCondition callBack:^(NSArray<NSObject *> *models) {
        if (models.count) {
            DCardModel*cardModel=models[0];
            [weakSelf pushPublishCardViewController:cardModel];
        }
    }];
    


    
    
}
//设置透明度
-(void)initializeSliderView{
    self.transparency=300;
    self.sliderView=[[DSliderView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    [self.navigationController.view addSubview:self.sliderView];
    if ([DataManager getDataKey:kTransparency]) {
        NSString*transparency=[DataManager getDataKey:kTransparency];
        self.sliderView.slider.value =[transparency floatValue]*100;
    }else{
        self.sliderView.slider.value = 91;
    }
    WEAKSELF
    self.sliderView.slider.transparencyUpdateTata = ^(NSInteger transparency) {
        if (weakSelf.transparency!=transparency) {
            weakSelf.transparency=transparency;
            weakSelf.backgroundView.backgroundColor=AppAlphaColor(0, 0, 0,((float)transparency/100));
            [DataManager setDataKey:kTransparency data:[NSString stringWithFormat:@"%f",((float)transparency/100)]];
        }
    };
}
-(void)addBarButton{
    self.title=Localized(@"Home1");
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonItemTaget:self action:@selector(rightBarButtonClick) imageNormal:@"已创建" imageHighlighted:@""];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem barButtonItemTaget:self action:@selector(leftBarButtonClick) imageNormal:@"背景调整" imageHighlighted:@""];
}
-(void)rightBarButtonClick{
    if (self.choseView.hidden==NO) {
         [self dismissSphereView];
    }
     DHasCreatedVC*VC=[[DHasCreatedVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    WEAKSELF
    VC.updateTata = ^(DBaseModel * _Nonnull model, NSUInteger typeIndex) {
        [weakSelf refreshBaseModel:model PrimaryID:typeIndex];
    };
}
-(void)leftBarButtonClick{
    [self.sliderView show];
}
//刷新
-(void)refreshBaseModel:(DHomeModel*)model PrimaryID:(NSInteger)primaryID{
    for (int i=0; i<self.homeViewArray.count;i++) {
        DHomeView*homeView=self.homeViewArray[i];
        if (homeView.model.primaryID==primaryID) {
            [homeView setData:model];
             return;
        }
}}
-(void)initializeRefresh:(BOOL)isRemove{
    WEAKSELF
    [DHomeModel selectFromStart:0 totalCount:50 models:^(NSArray<NSObject *> *models) {
        
        if (isRemove) {
            [weakSelf.listArray removeAllObjects];
        }
        [weakSelf.listArray   addObjectsFromArray:models];
        if (!models.count) {
           weakSelf.listArray=[DHomeModel createData];
        }
        
       [weakSelf initsphereViews];
        NSLog(@"");
    }];
    
}

-(void)initializeBackgroundScrollView{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.backgroundColor=[UIColor  whiteColor];
    [self.view addSubview:self.backgroundScrollView ];
    [self.backgroundScrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.bgImageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    self.bgImageView.image = [YLGIFImage imageNamed:@"背景.gif"];
    [self.backgroundScrollView addSubview:self.bgImageView];
    
    UIView*backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    
    [self.backgroundScrollView addSubview:backgroundView];
    self.backgroundView=backgroundView;
    if ([DataManager getDataKey:kTransparency]) {
     NSString*transparency=[DataManager getDataKey:kTransparency];
      backgroundView.backgroundColor=AppAlphaColor(0, 0, 0, [transparency floatValue]);
    }else{
      backgroundView.backgroundColor=AppAlphaColor(0, 0, 0, 0.91);
    }
    
    
    self.sphereView = [[DSphereView alloc] initWithFrame:CGRectMake(0,80,kScreenWidth, kScreenHeight-80)];
    [self.backgroundScrollView addSubview:self.sphereView];
    
    //个人界面按钮
    self.suspensionButton.frame=CGRectMake(10,(iPhoneX ? kScreenHeight-70-100 :kScreenHeight-70-60) , 55, 55);
   
    
    self.choseView = [[DChoseView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, kScreenHeight)];
    [self.backgroundScrollView addSubview:self.choseView];
    [self.choseView.closeButton addTarget:self action:@selector(dismissSphereView) forControlEvents:UIControlEventTouchUpInside];
    [self.choseView.sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    self.choseView.hidden=YES;
}
#pragma 星球转动
-(void)initsphereViews{
    for (NSInteger i = 0; i < self.listArray.count; i ++) {
        DHomeView*homeView=[self initializeHomeView:i];
        [self.homeViewArray addObject:homeView];
        [self.sphereView addSubview:homeView];
    }
    [self.sphereView setCloudTags:self.homeViewArray];
    
}
-(DHomeView*)initializeHomeView:(NSInteger)row{
    DHomeView*homeView=[[DHomeView alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    DHomeModel*model=self.listArray[row];
    [homeView setData:model];
    homeView.tag=row;
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
   [homeView addGestureRecognizer:tapGes];
    
    return homeView;
}
- (void)tapGes:(UITapGestureRecognizer*)ges{
    DHomeView*homeView=ges.view;
    [self showSphereView:homeView];
    
}

#pragma  点击按钮弹出
-(void)showSphereView:(DHomeView*)homeView
{
    WEAKSELF
    self.choseView.hidden=NO;
    self.selectedHomeView=homeView;
    self.choseView.model =homeView.model;
    [self.choseView refreshData];
    
    self.choseView.cardView.updateTata = ^(DCardModel * _Nonnull model, NSInteger curIndex) {
        [weakSelf pushPublishCardViewController:model curIndex:curIndex];
       
    };
    self.choseView.imgBegan = ^{
        [weakSelf showAssetPickerController];
    };
    self.choseView.completeUpdateTata = ^(NSString * _Nonnull text) {
        homeView.model.homeTitle=text;
        [homeView.model save:nil];
        [homeView setData:homeView.model];
    };
    
    center = self.sphereView.center;
    center.y -= 100;
    [UIView animateWithDuration: 0.35 animations: ^{
        
        self.sphereView.center = self->center;
        self.sphereView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7,0.7);
        self.choseView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        //        self.gesturesView.hidden=NO;
        
    } completion: nil];
    
    
}
- (void)showAssetPickerController{

    WEAKSELF
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowPickingVideo=NO;
    imagePickerVc.showSelectBtn=NO;
    imagePickerVc.allowCrop=YES;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage  *photo=photos[0];
        weakSelf.selectedHomeView.model.ico=[DataManager saveImage:photo];
        [weakSelf.selectedHomeView.model save:nil];
        [weakSelf modifyModel];
        weakSelf.choseView.coverImg.image=photo;
        [weakSelf.selectedHomeView setData:weakSelf.selectedHomeView.model];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



//推出内容卡片
-(void)pushPublishCardViewController:(DCardModel *)cardModel curIndex:(NSInteger)curIndex{
   
    if ([cardModel.cardCover isEqualToString:@"首页封面提示"]) {
        cardModel=nil;
    }
    [self pushPublishCardViewController:cardModel];
    
}
-(void)pushPublishCardViewController:(DCardModel *)cardModel{
    DPublishCardVC * VC = [[DPublishCardVC alloc]init];
    WEAKSELF
    VC.cardUpdateTata = ^(DCardModel * _Nonnull model, BOOL isAdd) {
        if (isAdd) {
            [weakSelf modifyModel];
            weakSelf.selectedHomeView.model.completeProportion+=1;
            [weakSelf.selectedHomeView setData:weakSelf.selectedHomeView.model];
            [weakSelf.selectedHomeView.model save:nil];
        }
        [self.choseView refreshData];
    };
    
    
    VC.model=cardModel;
    VC.superiorID=self.selectedHomeView.model.downID;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)modifyModel{
    if (self.selectedHomeView.model.stateType==kStateWaiting) {
        self.selectedHomeView.model.stateType=kStateOngoing;
        self.selectedHomeView.model.homeTitle=Localized(@"Home6");
        [self.choseView refreshData];
    }
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismissSphereView
{
    self.choseView.titleTextView.hidden=YES;
    self.choseView.completeButton.hidden=YES;
    self.choseView.titleLabel.hidden=NO;
    [self.choseView.titleTextView resignFirstResponder];
    
    center.y += 100;
   [UIView animateWithDuration: 0.35 animations: ^{
        self.choseView.frame =CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
      
        self.sphereView.center = self->center;
        self.sphereView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        
   } completion:^(BOOL finished) {
       self.choseView.hidden=YES;
   }];
    
}
//确定
-(void)sureClick{
  
    //移除
    if (self.selectedHomeView.model.stateType==kStateOngoing) {
        WEAKSELF
        [DBusiness homeDeletePop:Localized(@"Popout3") successful:^(NSDictionary * _Nonnull responseObject) {
                        DRecycleModel*recycleModel=[DRecycleModel crateModel];
                        [recycleModel saveModel:weakSelf.selectedHomeView.model];
            
            
                        [weakSelf.selectedHomeView.model reset];
                        [weakSelf.selectedHomeView setData:weakSelf.selectedHomeView.model];
            
            
                        [EasyTextView showSuccessText:@"移除成功" config:^EasyTextConfig *{
                             return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(RecommendedColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
                        }];
            
            
                        [weakSelf  dismissSphereView];
        }];
        
    }else{
               [self  dismissSphereView];
    }
}

/// 悬浮按钮view
- (UIButton *)suspensionButton{
    if (!_suspensionButton) {
        _suspensionButton = [[UIButton alloc]init];
        [_suspensionButton addTarget:self action:@selector(personalMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_suspensionButton setImage:ImageNamed(@"飞碟") forState:0];
        [self.backgroundScrollView addSubview:_suspensionButton];
    }
    return _suspensionButton;
}
//推出个人界面
-(void)personalMenuAction:(UIButton*)button{
    [button springPopAnimation];
    DPersonalMenuVC*VC=[DPersonalMenuVC new];
    VC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    DNavigationController*ngVC= [[DNavigationController alloc] initWithRootViewController:VC];
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf presentViewController:ngVC animated:YES completion:nil];
        });
    });
}






@end
