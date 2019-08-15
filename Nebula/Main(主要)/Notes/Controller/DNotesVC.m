//
//  DNotesVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DNotesVC.h"
#import "DNotesCell.h"
#import "DNotesModel.h"
#import "DAddNotesVC.h"
#import "DNotesDetailsVC.h"
#import "UIScrollView+ZRRefresh.h"

@interface DNotesVC ()<AnimatorPresentedDelegate>
@property (strong, nonatomic) NSMutableArray  *photoList;
@property (strong, nonatomic) UIImageView      *imgView;
@end

@implementation DNotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=Localized(@"Card5");
    [self addBackItem];
    [self addHeadRefresh];
    [self seacrhTable:YES];
    
    if (self.cardTitle.length>15) {
        self.tableView.zr_header.text=[NSString stringWithFormat:@"%@..", [self.cardTitle substringToIndex:13]];
    }else{
        self.tableView.zr_header.text=self.cardTitle;
    }
    
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonItemTaget:self action:@selector(rightBarButtonClick) imageNormal:@"添加笔记" imageHighlighted:@""];
    
    self.imgView=[UIImageView new];
}
- (void)onFooterRefreshing{
    NSLog(@"上啦");
    [self seacrhTable:NO];
}
-(void)dataProcessingIsRemove:(BOOL)isRemove{
    WEAKSELF
    TODBCondition *searchCondition=[TODBCondition condition:@"superiorID" equalTo:self.superiorID];
   [DNotesModel search:searchCondition startIndex:self.page totalCount:self.count callBack:^(NSArray<NSObject *> *models) {
        if (isRemove) {
            [weakSelf.listArray removeAllObjects];
        }
        if (models.count) {
            weakSelf.page++;
        }
        [weakSelf.listArray addObjectsFromArray:models];
        [weakSelf endNetworkRequest];
        [weakSelf.tableView reloadData];
    }];
    
}
-(void)rightBarButtonClick{
    NSLog(@"%@",self.superiorID);
    WEAKSELF
    DAddNotesVC*VC=[DAddNotesVC new];
    VC.superiorID=self.superiorID;
    VC.updateTata = ^(DBaseModel * _Nonnull model, NSUInteger typeIndex) {
      
        [weakSelf seacrhTable:YES];
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNotesModel *model = self.listArray[indexPath.row];
    return model.cellHeight;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArray.count) {
        self.emptyImageView.hidden=YES;
    }else{
        self.emptyImageView.hidden=NO;
    }
    return self.listArray.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    DNotesCell *cell = [DNotesCell cellWithTableView:tableView];
    DNotesModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    cell.singleTapGestureBlock = ^(NSInteger tag, UIView * _Nonnull view) {
        [weakSelf browsePictures:model.photoList indexPath:[NSIndexPath indexPathForRow:tag inSection:0] imageView:view];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DNotesModel *model  = self.listArray[indexPath.row];
    DNotesDetailsVC*VC  = [DNotesDetailsVC new];
    VC.model            = model;
    VC.cardModel        = self.cardModel;
    [self.navigationController pushViewController:VC animated:YES];
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
    self.imgView.image=self.photoList[index.row];
    return self.imgView;
}
@end
