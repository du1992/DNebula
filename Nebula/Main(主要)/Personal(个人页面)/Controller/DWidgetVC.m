//
//  DWidgetVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/3/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DWidgetVC.h"
#import "DWidgetCell.h"
#import "DCardModel.h"
#import "DPublishCardVC.h"

@interface DWidgetVC (){
        NSUserDefaults *userDefault;
        NSTimer *_timer;
}

@end

@implementation DWidgetVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
   
    [self addBackItem];
    self.title=Localized(@"Personal1");
    
     userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.kevindcw.notebook.NebulaWidget"];
    
  

    [self addRightBarButtonItem:Localized(@"Home4")];
    
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self dataRefresh];
    
}
-(void)dataRefresh{
     [self.listArray removeAllObjects];
    NSArray*array= [userDefault valueForKey:@"modelArray"];
    for (int i = 0; i<array.count; i++) {
        NSString*key=array[i];
        NSDictionary*dic=[userDefault valueForKey:key];
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
}

-(void)rightItem{
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.navigationItem.rightBarButtonItem.title = self.tableView.editing?Localized(@"Home5"): Localized(@"Home4");
}
-(void)timerRefresh{
    if (!self.tableView.editing) {
       [self.tableView   reloadData];
    }
}
#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
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
    DWidgetCell *cell = [DWidgetCell cellWithTableView:tableView];
    DTodayModel*model = self.listArray[indexPath.row];
    [cell setWidgetData:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTodayModel*model = self.listArray[indexPath.row];
    WEAKSELF
    TODBCondition *searchCondition=[TODBCondition condition:@"primaryID" equalTo:model.openNewsID];
    [DCardModel search:searchCondition callBack:^(NSArray<NSObject *> *models) {
        if (models.count) {
            DCardModel*cardModel=models[0];
            [weakSelf pushPublishCardViewController:cardModel];
        }
    }];
}



//删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        NSArray*array= [userDefault valueForKey:@"modelArray"];
        NSString*key=array[indexPath.row];
        NSMutableArray* modelArray=[NSMutableArray array];
        [modelArray addObjectsFromArray:array];
        [userDefault setValue:nil forKey:key];
        [modelArray removeObject:key];
        [userDefault setValue:modelArray forKey:@"modelArray"];
        
        
        [self.listArray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

-(void)pushPublishCardViewController:(DCardModel *)cardModel{
    DPublishCardVC * VC = [[DPublishCardVC alloc]init];
    WEAKSELF
    VC.cardUpdateTata = ^(DCardModel * _Nonnull model, BOOL isAdd) {
        
        [weakSelf dataRefresh];
    };
    VC.model=cardModel;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
