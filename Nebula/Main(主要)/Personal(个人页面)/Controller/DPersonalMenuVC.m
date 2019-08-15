//
//  DPersonalViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DPersonalMenuVC.h"
#import "DHomeCorrugatedView.h"
#import "DMenuModel.h"
#import "DRecycleVC.h"
#import "DWidgetVC.h"
#import "DInstructionsVC.h"

#define itemHeight 150
@interface DPersonalMenuVC (){
     UIImageView *topView;
}

@property(nonatomic,strong)YLImageView         * imageView1;
@property(nonatomic,strong)DHomeCorrugatedView * strechy;
@property(nonatomic,strong)UIButton            * suspensionButton;
@end

@implementation DPersonalMenuVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeModel];
    [self initHeaderView];
    [self initTableView];
    
     self.suspensionButton.frame=CGRectMake(10, kScreenHeight-70, 55, 55);
}

- (void)initHeaderView{
    
    //头
    topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 200)];
    [topView setImage:[UIImage imageNamed:@"bg"]];
    [topView setBackgroundColor:AppColor(128, 26, 26)];
    
    
    __weak typeof(self)weakSelf = self;
    _imageView1 = [[YLImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, 100, 80, 80)];
    _imageView1.image = [YLGIFImage imageNamed:@"地球旋转.gif"];
    [topView addSubview:_imageView1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 20)];
    [label setText:Localized(@"Home1")];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.imageView1.mas_bottom).offset (10);
        make.centerX.equalTo (self->topView);
    }];
    
    
}
- (void)initTableView{
    //内容列表
    __weak typeof(self)weakSelf = self;
    _strechy = [[DHomeCorrugatedView alloc] initWithFrame:self.view.frame andTopView:topView];
    [self.view addSubview:_strechy];
    _strechy.headerView.waveBlock = ^(CGFloat currentY){
        
        CGRect iconFrame = [weakSelf.imageView1 frame];
        iconFrame.origin.y = CGRectGetHeight(weakSelf.imageView1.frame)+currentY-weakSelf.strechy.headerView.waveHeight;
        weakSelf.imageView1.frame  =iconFrame;
    };
    
    _strechy.backgroundColor=AppColor(225,238, 210);
    float itemStartY = topView.frame.size.height + 10;
    for (int i = 0; i < self.listArray.count; i++) {
        [_strechy addSubview:[self scrollViewItemWithY:itemStartY andNumber:i]];
        itemStartY += (itemHeight+10);
    }
    [_strechy setContentSize:CGSizeMake(kScreenWidth, itemStartY)];
   
    
}

- (UIView *)scrollViewItemWithY:(CGFloat)y andNumber:(int)num {
    DMenuModel*model=self.listArray[num];
    
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth-20, itemHeight)];
    [item setUserInteractionEnabled:YES];
    UIButton*button=[[UIButton alloc]init];
    [item addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(item);
    }];
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=num;
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(item.frame.size.width/2-25,itemHeight/2-50, 50, 50)];
    img.image=model.ico;
    [self lableWithSuoerView:img text:model.title textColor:[UIColor whiteColor] textFountSize:16];
    [item addSubview:img];
    [item setBackgroundColor:model.color];
    item.clipsToBounds = YES;
    item.layer.borderWidth =0.5;
    item.layer.borderColor = AppColor(81, 41, 23).CGColor;
    item.layer.cornerRadius = 15;
    item.alpha=0.7;
    return item;
    
}
-(UILabel*)lableWithSuoerView:(UIView *)superView text:(NSString *)text textColor:(UIColor *)textColor textFountSize:(NSInteger )fountSize {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:fountSize];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (superView.mas_bottom).offset (10);
        make.centerX.equalTo (superView);
    }];
    label.shadowColor = AppColor(81, 41, 23);//阴影颜色
    label.shadowOffset = CGSizeMake(0.3, 0.3); //阴影偏移  x，y为正表示向右下偏移
    return label;
}
//推出界面
-(void)shareButtonAction:(UIButton*)button{
    DMenuModel*model=self.listArray[button.tag];

    if ([model.title isEqualToString:modelAString]) {
        DRecycleVC*VC=[[DRecycleVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([model.title isEqualToString:modelBString]){
       
        DWidgetVC*VC=[[DWidgetVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }else if ([model.title isEqualToString:modelCString]){
        
        DInstructionsVC*VC=[[DInstructionsVC alloc]init];
         [self presentViewController:VC animated:YES completion:nil];
        
    }else if ([model.title isEqualToString:modelDString]){
          NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1185429183?mt=8&action=write-review";[[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
        
    }else if ([model.title isEqualToString:modelEString]){
        
        
    }else if ([model.title isEqualToString:modelFString]){
        
        
    }
    
    
   
}



-(void)initializeModel{
    DMenuModel*modelA=[DMenuModel new];
    modelA.title=modelAString;
    modelA.ico=[UIImage imageNamed:@"星0"];
    modelA.color=AppColor(30, 144, 255);
    [self.listArray addObject:modelA];
    
    DMenuModel*modelB=[DMenuModel new];
    modelB.title=modelBString;
    modelB.ico=[UIImage imageNamed:@"星1"];
    modelB.color=AppColor(0, 238, 118);
    [self.listArray addObject:modelB];

    
    DMenuModel*modelC=[DMenuModel new];
    modelC.title=modelCString;
    modelC.ico=[UIImage imageNamed:@"星2"];
    modelC.color= AppColor(255, 215, 0);
    [self.listArray addObject:modelC];
    
    
    DMenuModel*modelD=[DMenuModel new];
    modelD.title=modelDString;
    modelD.ico=[UIImage imageNamed:@"星3"];
    modelD.color=AppColor(205, 38, 38);
    [self.listArray addObject:modelD];
//
//    DMenuModel*modelE=[DMenuModel new];
//    modelE.title=modelEString;
//    modelE.ico=[UIImage imageNamed:@"星4"];
//    modelE.color=AppColor(205, 102, 29);
//    [self.listArray addObject:modelE];
    
    
    
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
