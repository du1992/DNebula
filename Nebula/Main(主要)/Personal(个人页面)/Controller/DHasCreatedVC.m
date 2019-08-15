//
//  DHasCreatedVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHasCreatedVC.h"
#import "DRecycleCell.h"
#import "DHomeModel.h"
#import "DRecycleModel.h"
#import "DChoseView.h"
#import "DPublishCardVC.h"

@interface DHasCreatedVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) DChoseView       *choseView;

@property (nonatomic, strong) DHomeModel       *homeModel;


@end

@implementation DHasCreatedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.curIndex=1000;
    self.title=Localized(@"Home7");
    
    
    [self addBackItem];
    [self initializeRefresh:YES];
    [self initializeChoseView];
}

-(void)initializeRefresh:(BOOL)isRemove{
    WEAKSELF
    TODBCondition *searchCondition=[TODBCondition condition:@"stateType" equalTo:@"1"];
    [DHomeModel search:searchCondition callBack:^(NSArray<NSObject *> *models) {
        if (isRemove) {
            [weakSelf.listArray removeAllObjects];
        }
        [weakSelf.listArray   addObjectsFromArray:models];
        [weakSelf.tableView   reloadData];
    }];
}
-(void)initializeChoseView{
   
    self.choseView = [[DChoseView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    self.choseView.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth, 370);
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
                weakSelf.homeModel.homeTitle=text;
                [weakSelf.homeModel save:nil];
                [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.homeModel];
                [weakSelf.tableView   reloadData];
                weakSelf.updateTata(weakSelf.homeModel, weakSelf.homeModel.primaryID);
    };
     self.choseView.hidden=YES;
}
//推出内容卡片
-(void)pushPublishCardViewController:(DCardModel *)cardModel curIndex:(NSInteger)curIndex{
    DPublishCardVC * VC = [[DPublishCardVC alloc]init];
    
    WEAKSELF
    VC.cardUpdateTata = ^(DCardModel * _Nonnull model, BOOL isAdd) {
        if (isAdd) {
             weakSelf.homeModel.completeProportion+=1;
            [weakSelf.homeModel save:nil];
            weakSelf.updateTata(weakSelf.homeModel, weakSelf.homeModel.primaryID);
            [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.homeModel];
            [weakSelf.tableView   reloadData];
        }
        [weakSelf.choseView refreshData];
    };
    if ([cardModel.cardCover isEqualToString:@"首页封面提示"]) {
        cardModel=nil;
    }
    
    VC.model=cardModel;
    VC.superiorID=self.homeModel.downID;
    [weakSelf.navigationController pushViewController:VC animated:YES];
    
}
//确定
-(void)sureClick{
    
    //移除
    if (self.homeModel.stateType==kStateOngoing) {
        WEAKSELF
        [DBusiness homeDeletePop:Localized(@"Popout3") successful:^(NSDictionary * _Nonnull responseObject) {
            DRecycleModel*recycleModel=[DRecycleModel crateModel];
            [recycleModel saveModel:weakSelf.homeModel];
            
            
            [weakSelf.homeModel reset];
            [weakSelf.listArray removeObjectAtIndex:weakSelf.curIndex];
            [weakSelf.tableView reloadData];
            
            
            [EasyTextView showSuccessText:@"移除成功" config:^EasyTextConfig *{
                return [EasyTextConfig shared].setShadowColor([UIColor redColor]).setBgColor(RecommendedColor).setTitleColor([UIColor whiteColor]).setStatusType(TextStatusTypeNavigation);
            }];
            
             weakSelf.updateTata(weakSelf.homeModel, weakSelf.homeModel.primaryID);
            [weakSelf  dismissSphereView];
        }];
        
    }else{
        [self  dismissSphereView];
    }
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
         weakSelf.homeModel.ico=[DataManager saveImage:photo];
        [weakSelf.homeModel save:nil];
        weakSelf.choseView.coverImg.image=photo;
        [weakSelf.listArray replaceObjectAtIndex:weakSelf.curIndex withObject:weakSelf.homeModel];
        [weakSelf.tableView   reloadData];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
    DHomeModel *model = self.listArray[indexPath.row];
    [cell setData:model];
    if (self.curIndex==indexPath.row) {
        cell.selectedImageView.hidden=NO;
    }else{
        cell.selectedImageView.hidden=YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DHomeModel *model = self.listArray[indexPath.row];
    self.homeModel=model;
    [self showSphereView:model];
    self.curIndex=indexPath.row;
    [self.tableView reloadData];
    //    if (self.chooseMusicUpdateTata) {
    //        self.chooseMusicUpdateTata(model);
    //    }
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

@end
