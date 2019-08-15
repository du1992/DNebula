//
//  DNotesDetailsVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DNotesDetailsVC.h"
#import "DPhotoTableViewCell.h" 
#import "DNotesCell.h"

@interface DNotesDetailsVC ()<AnimatorPresentedDelegate>
@property (strong, nonatomic) NSMutableArray  *photoList;
@property (strong, nonatomic) DNotesHeadView  *headerView;

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * commentBJView;

@property (nonatomic, strong) UIButton    * backButton;
@property (nonatomic, strong) UIButton    * likeButton;
@property (nonatomic, strong) UIButton    * shareButton;
@property (nonatomic, strong) UIButton    * commentButton;
@property (nonatomic, strong) UIButton    * applyButton;

@end

@implementation DNotesDetailsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_headerView.timeLabel_hsf.timer invalidate];
    _headerView.timeLabel_hsf.timer=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"笔记详情";
    [self addBackItem];
    [self setUpTopButton];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = (IS_iPhoneX ? -45 : -25);
    [self.tableView setContentInset:contentInset];
     self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
}
- (void)setUpTopButton {
    self.backView = [UIView new];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(IS_iPhoneX ? 88 : 64));
    }];
    
//    UILabel*title=[UILabel new];
//    title.textColor=[UIColor whiteColor];
//    [self.backView addSubview:title];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.backView);
//    }];
//    title.text=Localized(@"Notes4");
    
    
    
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
    
    
    
    
    
//    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.backView addSubview:self.likeButton];
//    [self.likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.likeButton setImage:[UIImage imageNamed:@"收藏图标"] forState:UIControlStateNormal];
//    [self.likeButton setImage:[UIImage imageNamed:@"已经收藏图标"] forState:UIControlStateSelected];
//    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(26, 26));
//        make.centerY.equalTo(self.backButton);
//        make.right.equalTo(self.shareButton.mas_left).offset(-20);
//    }];
  
   
    
}
//分享
-(void)shareButtonClicked{
    UIImage *imageToShare = [self captureScrollView:self.tableView];
    if (imageToShare) {
        NSArray *itemArr = @[imageToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems: itemArr applicationActivities:nil];
        [self presentViewController: activityVC animated:YES completion:nil];
    }else{
        [EasyTextView showErrorText:Localized(@"Notes5") config:^EasyTextConfig *{
            return [EasyTextConfig shared].setStatusType(TextStatusTypeNavigation).setBgColor(DangerousColor);
        }];
    }
   
}
- (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
        return [UIImage imageWithData: imageData];
    }
    return nil;
}


-(UIImage*)getViewImg{
    CGSize s =self.tableView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
    return [UIImage imageWithData: imageData];
    
}
-(void)initializeData{
    for (int i=0; i<self.model.photoList.count; i++) {
        DPhotoModel *model = [DPhotoModel new];
        model.photoImg     = [DataManager getImage:self.model.photoList[i]];
        model.photoHeight  = (kScreenWidth - 15 * 2) * (model.photoImg.size.height / model.photoImg.size.width) + 8;
        [self.listArray addObject:model];
    }
    [self.tableView reloadData];
}
//初始化区头
-(void)initializeTableHeaderView{
   
   CGFloat textHeight=self.model.textHeight+200+60+30;
    _headerView=[[DNotesHeadView alloc]init];
    _headerView.frame=CGRectMake(0, 0,kScreenWidth, textHeight);
    self.tableView.tableHeaderView = _headerView;

    _headerView.bjImageView.image=[self.cardModel getCoverImage];
    _headerView.introduce.text   =self.cardModel.cardTitle;
    _headerView.textView.text    =self.model.notesTextContent;
    
    
    if (self.cardModel.chooseTime.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *selectDate=[formatter dateFromString:self.cardModel.chooseTime];
        [self nowTimeInterval:selectDate isSelect:NO TimeType:self.cardModel.timeType];
        
    }else{
        NSUInteger curentTime=60 * 60 * 24 * 3;
        [_headerView.timeLabel_hsf setcurentTime:curentTime timeType:self.cardModel.timeType];
    }
}
-(BOOL)nowTimeInterval:(NSDate *)selectDate isSelect:(BOOL)isSelect TimeType:(NSInteger)timeType{
    NSDate *datenow = [NSDate date];
    NSTimeInterval nowTime = [datenow timeIntervalSince1970];
    long long int nowDate = (long long int)nowTime;
    
    NSTimeInterval selectTime = [selectDate  timeIntervalSince1970];
    long long int select = (long long int)selectTime;
    
    
    NSUInteger date;
    if (self.cardModel.timeType) {
        date = nowDate - select;
        
    }else{
        date = select-nowDate;
    }
    if (!timeType&&nowTime>selectTime) {
         [EasyTextView showInfoText:[NSString stringWithFormat:@"【%@】%@",Localized(@"Card1"),Localized(@"Card3")] config:^EasyTextConfig *{
            return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
        }];
        
        return YES;
    }
    if (timeType&&selectTime>nowTime) {
        
        
        [EasyTextView showInfoText:[NSString stringWithFormat:@"【%@】%@",Localized(@"Card2"),Localized(@"Card4")]  config:^EasyTextConfig *{
            return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(WarningColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
        }];
        
        
        return YES;
    }
    
    [_headerView.timeLabel_hsf setcurentTime:date timeType:self.cardModel.timeType];
    
    return NO;
}
#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPhotoModel *model = self.listArray[indexPath.row];
    return model.photoHeight;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArray.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPhotoTableViewCell *cell = [DPhotoTableViewCell cellWithTableView:tableView];
    DPhotoModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPhotoTableViewCell *cell = (DPhotoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self browsePictures:self.model.photoList indexPath:indexPath imageView:cell.notesImage];
}

-(void)browsePictures:(NSArray*)imgArray indexPath:(NSIndexPath*)indexPath imageView:(UIImageView *) imageView{
    if (self.photoList) {
        [self.photoList removeAllObjects];
        self.photoList=nil;
    }
    
    NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<imgArray.count; i++) {
        NSString* object   =imgArray[i];
        [array addObject:[DataManager getImage:object]];
    }
    self.photoList=array;
    // 1. 创建动画配置类
    YCPhotoBrowserAnimator *browserAnimator = [[YCPhotoBrowserAnimator alloc] initWithPresentedDelegate:self];
    YCPhotoBrowserController *vc = [YCPhotoBrowserController instanceWithShowImages:array];
    vc.placeholder = imageView.image;
    // 设置点击的下标，没设置则从第一张开始
    vc.indexPath = indexPath;
    // 设置动画，没设置则没动画
    vc.browserAnimator = browserAnimator;
    ///还可以设置指示视图位置，类型，长按的回调。。。
    
    // 4.弹出图片控制器
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

#pragma mark - <AnimatorPresentedDelegate>
// 动画需要实现该协议，将动画的image传给动画类
- (UIImageView *)imageViewWithIndexPath:(NSIndexPath *)index{
    DPhotoTableViewCell *cell = (DPhotoTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
    return cell.notesImage;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y;
    if (offset <= 0) {
        CGRect rect = self.headerView.bjImageView.frame;
        rect.origin.y = offset;
        rect.size.height = -offset + 200;
        self.headerView.bjImageView.frame = rect;
        self.headerView.bgView.frame = rect;
    }
    if (offset >= 0) {
        CGFloat backViewAlpha = ((offset - 50) / 300.0);
        self.backView.backgroundColor = [UIColor colorWithWhite:0.f alpha:(backViewAlpha > 0.8 ? 0.8 : backViewAlpha)];
    }
}


@end
