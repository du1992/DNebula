//
//  DTableViewController.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTableViewController.h"
#import "UIScrollView+ZRRefresh.h"

#define TCTableViewDefaultBottmRefreshingMargin 800

@interface DTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
   
}


@end

@implementation DTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.zr_header reloadPath];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeTableView];
    [self initializeTableHeaderView];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.mas_equalTo(self.view);
    }];
    
}
-(void)initializeData{
    
}
-(void)initializeTableView{
    self.tableView=[DTableView new];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addFooterWithTarget:self action:@selector(onFooterRefreshing)];
    [self.view addSubview:self.tableView];
}
//初始化区头
-(void)initializeTableHeaderView{

}

//添加头部刷新
-(void)addHeadRefresh{
    WEAKSELF
   self.tableView.zr_header = [ZRRefreshHeader refreshHeaderWithAnimationConfig:[[ZRRefreshAnimationConfig alloc] init] refreshingHandler:^{
         [weakSelf onHeaderRefreshing];
    }];
    self.tableView.zr_header.textFont          =AppFont(30);
    self.tableView.zr_header.textColor         =RecommendedColor;
    self.tableView.zr_header.refresingLineColor=DangerousColor;
}
- (void)onFooterRefreshing{
    NSLog(@"上啦");
   
}
- (void)onHeaderRefreshing{
    NSLog(@"下啦");
    [self seacrhTable:YES];
}

-(void)endNetworkRequest{
     [self.indicatorAnimationView removeAllAnimation];
     [self.tableView.zr_header endRefreshing];
    [self.tableView stopRefreshingAndLoading];
     self.isRefresh=NO;
}
-(void)seacrhTable:(BOOL)isRemove{
    if (self.isRefresh) {
        [self endNetworkRequest];
        return;
    }
    self.isRefresh=YES;
    
    
    if (isRemove) {
        self.page=0;
    }else{
        [self.indicatorAnimationView startAllAnimation];
    }
    [self dataProcessingIsRemove:isRemove];
}
//数据处理
-(void)dataProcessingIsRemove:(BOOL)isRemove{
   
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 200;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UIImageView *)emptyImageView {
    if (_emptyImageView == nil) {
        _emptyImageView = [UIImageView new];
        [self.view addSubview:_emptyImageView];
        _emptyImageView.contentMode=UIViewContentModeScaleAspectFit;
        _emptyImageView.image=ImageNamed(@"无数据");
        _emptyImageView.hidden=YES;
    }
    return _emptyImageView;
}



@end
