//
//  TodayViewController.m
//  NebulaWidget
//
//  Created by DUCHENGWEN on 2019/2/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Masonry.h"
#import "DTodayCell.h"
#import "DTodayModel.h"


#define stsystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

#define cellHeight 90

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>{
    NSUserDefaults *userDefault;
    NSTimer *_timer;
}

@property (nonatomic, strong) UITableView         *tableView;

@property (nonatomic, strong) NSMutableArray      *listArray;
@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置折叠还是展开
    // 设置展开才会展示，设置折叠无效，左上角不会出现按钮， ❓
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    if (!_timer) {
        _timer= [NSTimer timerWithTimeInterval:1
                                        target:self
                                      selector:@selector(timerRefresh)
                                      userInfo:nil
                                       repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.listArray=[NSMutableArray array];
    
    [self initializeTableView];
//    [self initializeBottomView];
    
    userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.kevindcw.notebook.NebulaWidget"];
    
    NSArray*array= [userDefault valueForKey:@"modelArray"];
    for (int i = 0; i<array.count; i++) {
        NSString*key=array[i];
        NSMutableDictionary*dic=[userDefault valueForKey:key];
        if (dic) {
            DTodayModel*model  = [DTodayModel new];
            model.openNewsID   = key;
            model.cardTitle    = dic[@"cardTitle"];
            model.timeType     = dic[@"timeType"];
            model.chooseTime   = dic[@"chooseTime"];
            [self.listArray addObject:model];
        }
    }
    [self.tableView   reloadData];
    
  
    
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
   
    
    [self setPreferredContentSize:CGSizeMake(self.view.frame.size.width, cellHeight*array.count+5)];
}
-(void)initializeTableView{
     self.tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
     self.tableView.dataSource  = self;
     self.tableView.delegate = self;
     self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }]; 
}
-(void)initializeBottomView{
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    footBtn.layer.cornerRadius = 5;
    [footBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:.3]];
    [self.view addSubview:footBtn];
    [footBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12.5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@25);
    }];
    
    
}
//进入主APP
- (void)moreAction {
    [self.extensionContext openURL:[NSURL URLWithString:@"NebulaiOSWidgetApp://action=openAPP"] completionHandler:nil];
}
#pragma mark - 定时更新机制
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
//    NSArray *devices = [[WWTKGroupDataManager shareInstance] readDevices];
//    
//    // 不是则刷新
//    if (self.devices.count < devices.count) {
//        self.devices = devices;
//            [self.tableView reloadData];
//    }

    completionHandler(NCUpdateResultNewData);
}


// 展开／折叠监听
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{

    if (activeDisplayMode == NCWidgetDisplayModeCompact) { //折叠
        // 折叠后的大小是固定的，目前测试的更改无效，默认高度应该是110
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    }else { // 展开
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, cellHeight*self.listArray.count+5);
    }
}



-(void)timerRefresh{

        [self.tableView   reloadData];

}
#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellHeight;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArray.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTodayCell *cell = [DTodayCell cellWithTableView:tableView];
    DTodayModel*model = self.listArray[indexPath.row];
    [cell setWidgetData:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    DTodayModel*model = self.listArray[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"NebulaiOSWidgetApp://action=openNewsID=%@",model.openNewsID];
    [self.extensionContext openURL:[NSURL URLWithString:string] completionHandler:nil];
}

@end
