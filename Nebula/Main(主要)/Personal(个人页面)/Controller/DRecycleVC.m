//
//  DRecycleVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DRecycleVC.h"
#import "DRecycleCell.h"
#import "DRecycleModel.h"
#import "DChoseView.h"
#import "UIScrollView+ZRRefresh.h"
#import "DPublishCardVC.h"
@interface DRecycleVC ()

@property (nonatomic, strong) DChoseView       *choseView;

@property (nonatomic, strong) DRecycleModel    *recycleModel;

@end

@implementation DRecycleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.curIndex=5000;
    self.title=Localized(@"Personal0");
    
    
    [self addBackItem];
    [self initializeChoseView];
    [self addHeadRefresh];
    [self seacrhTable:YES];
    self.tableView.zr_header.text=Localized(@"Personal0");
    
    
}
- (void)onFooterRefreshing{
    NSLog(@"上啦");
    [self seacrhTable:NO];
}
-(void)dataProcessingIsRemove:(BOOL)isRemove{
    WEAKSELF
    [DRecycleModel selectFromStart:self.page totalCount:self.count models:^(NSArray<NSObject *> *models) {
        if (isRemove) {
            [weakSelf.listArray removeAllObjects];
        }
        if (models.count) {
            weakSelf.page++;
        }
        [weakSelf.listArray addObjectsFromArray:models];
        [weakSelf endNetworkRequest];
        [weakSelf.tableView reloadData];
        NSLog(@"");
    }];
    
}
-(void)initializeChoseView{
   self.choseView = [[DChoseView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    self.choseView.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth, 410);
    self.choseView.hidden=YES;
    [self.choseView.closeButton addTarget:self action:@selector(dismissSphereView) forControlEvents:UIControlEventTouchUpInside];
    [self.choseView.sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.choseView];
    WEAKSELF
    self.choseView.cardView.updateTata = ^(DCardModel * _Nonnull model, NSInteger curIndex) {
        [weakSelf pushPublishCardViewController:model curIndex:curIndex];
        
    };
    self.choseView.imgBegan = ^{
        [weakSelf showAssetPickerController];
    };
    self.choseView.completeUpdateTata = ^(NSString * _Nonnull text) {
        weakSelf.recycleModel.homeTitle=text;
        [weakSelf.recycleModel save:nil];
        [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.recycleModel];
        [weakSelf.tableView   reloadData];
    };
}
//确定
-(void)sureClick{
    
    //移除
//    if (self.selectedHomeView.model.stateType==kStateOngoing) {
//        WEAKSELF
//        [DBusiness homeDeletePop:Localized(@"Popout3") successful:^(NSDictionary * _Nonnull responseObject) {
//            DRecycleModel*recycleModel=[DRecycleModel crateModel];
//            [recycleModel saveModel:weakSelf.selectedHomeView.model];
//
//
//            [weakSelf.selectedHomeView.model reset];
//            [weakSelf.selectedHomeView setData:weakSelf.selectedHomeView.model];
//
//
//            [EasyTextView showSuccessText:@"移除成功" config:^EasyTextConfig *{
//                return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(RecommendedColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
//            }];
//
//
//            [weakSelf  dismissSphereView];
//        }];
//
//    }else{
        [self  dismissSphereView];
//    }
}


#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
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
    DRecycleCell *cell = [DRecycleCell cellWithTableView:tableView];
    DRecycleModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    if (self.curIndex==indexPath.row) {
        cell.selectedImageView.hidden=NO;
    }else{
        cell.selectedImageView.hidden=YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DRecycleModel *model = self.listArray[indexPath.row];
    [self showSphereView:model];
    self.curIndex=indexPath.row;
    [self.tableView reloadData];
    self.recycleModel=model;
}
#pragma  点击按钮弹出
-(void)showSphereView:(DRecycleModel*)model
{
    self.choseView.model=model;
    [self.choseView refreshData];
    [self.choseView show];
}
//关闭
-(void)dismissSphereView{
    [self.choseView dismiss];
}

//推出内容卡片
-(void)pushPublishCardViewController:(DCardModel *)cardModel curIndex:(NSInteger)curIndex{
   DPublishCardVC * VC = [[DPublishCardVC alloc]init];
    WEAKSELF
    VC.cardUpdateTata = ^(DCardModel * _Nonnull model, BOOL isAdd) {
        if (isAdd) {
            weakSelf.recycleModel.completeProportion+=1;
            [weakSelf.recycleModel save:nil];
            [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.recycleModel];
            [weakSelf.tableView   reloadData];
        }
        [weakSelf.choseView refreshData];
    };
    if ([cardModel.cardCover isEqualToString:@"首页封面提示"]) {
        cardModel=nil;
    }
    
    VC.model=cardModel;
    VC.superiorID=self.recycleModel.downID;
    [weakSelf.navigationController pushViewController:VC animated:YES];
    
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
        weakSelf.recycleModel.ico=[DataManager saveImage:photo];
        [weakSelf.recycleModel save:nil];
        weakSelf.choseView.coverImg.image=photo;
        [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.recycleModel];
        [weakSelf.tableView   reloadData];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
@end
