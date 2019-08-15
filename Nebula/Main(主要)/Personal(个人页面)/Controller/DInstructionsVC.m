//
//  DInstructionsVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/3/15.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DInstructionsVC.h"
#import "DPhotoTableViewCell.h"


@interface DInstructionsVC ()<AnimatorPresentedDelegate>

@property (strong, nonatomic) NSMutableArray  *photoList;

@property(nonatomic,strong)  UIButton       * suspensionButton;

@end

@implementation DInstructionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
//     self.tableView.backgroundColor=AppColor(225,238, 210);
    self.tableView.backgroundColor=kColorControllerBackGround;
    self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.suspensionButton.frame=CGRectMake(10, kScreenHeight-70, 55, 55);
}

-(void)initializeData{
     for (int i=0; i<9; i++) {
        DPhotoModel *model = [DPhotoModel new];
         NSString*imgString=[NSString stringWithFormat:@"bz_%d",i];
        model.photoImg     = ImageNamed(imgString);
        model.photoHeight  = (kScreenWidth - 15 * 2) * (model.photoImg.size.height / model.photoImg.size.width) + 8;
        [self.listArray addObject:model];
    }
    [self.tableView reloadData];
}
//初始化区头
-(void)initializeTableHeaderView{
    UIView* _headerView=[[UIView alloc]init];
    _headerView.frame=CGRectMake(0, 0,kScreenWidth, 230);
    self.tableView.tableHeaderView = _headerView;
    
    UIImageView*imgView=[UIImageView new];
    imgView.image=ImageNamed(@"球图标");
    imgView.layer.cornerRadius=50;
    imgView.clipsToBounds = YES;
    imgView.layer.borderColor = DSkyColor.CGColor;
    imgView.layer.borderWidth = 2.0;
    [_headerView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView.mas_top).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(_headerView.mas_centerX);
    }];
    
    UILabel*tite=[UILabel new];
    tite.font = AppBoldFont(20);
    tite.textColor = DSkyColor;
    [tite setTextAlignment:NSTextAlignmentCenter];
    [_headerView addSubview:tite];
    tite.text=Localized(@"Personal2");
    [tite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(_headerView.mas_centerX);
    }];
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
    cell.backgroundColor=kColorControllerBackGround;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPhotoTableViewCell *cell = (DPhotoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self browsePictures:self.listArray indexPath:indexPath imageView:cell.notesImage];
}

-(void)browsePictures:(NSArray*)imgArray indexPath:(NSIndexPath*)indexPath imageView:(UIImageView *) imageView{
    


    
    
    
}

#pragma mark - <AnimatorPresentedDelegate>
// 动画需要实现该协议，将动画的image传给动画类
- (UIImageView *)imageViewWithIndexPath:(NSIndexPath *)index{
    DPhotoTableViewCell *cell = (DPhotoTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
    return cell.notesImage;
}



/// 悬浮按钮view
- (UIButton *)suspensionButton{
    if (!_suspensionButton) {
        _suspensionButton = [[UIButton alloc]init];
        [_suspensionButton addTarget:self action:@selector(personalMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_suspensionButton setImage:ImageNamed(@"个人关闭") forState:0];
        [self.view addSubview:_suspensionButton];
    }
    return _suspensionButton;
}
//返回
-(void)personalMenuAction:(UIButton*)button{
    [button springPopAnimation];
    //延迟加载
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        });
    });
}


@end
