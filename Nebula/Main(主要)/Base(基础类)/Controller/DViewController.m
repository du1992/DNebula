//
//  DViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DViewController.h"

@interface DViewController ()

@end

@implementation DViewController
//视图出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.indicatorAnimationView];
    [self.indicatorAnimationView resumeLayer];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.indicatorAnimationView=[[DIndicatorView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, 1)];
    [self.view addSubview:self.indicatorAnimationView];
    self.indicatorAnimationView.hidden=YES;
    self.count=12;
}
-(void)addBackItem{
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"导航栏返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem = backBarButton;
}
-(void)addRightBarButtonItem:(NSString*)title{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItem)];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName:WarningColor};
    [rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)rightItem{
    
}
- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
