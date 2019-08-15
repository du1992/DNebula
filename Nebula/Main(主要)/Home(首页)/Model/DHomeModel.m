//
//  DHomeModel.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHomeModel.h"

@implementation DHomeModel

+ (void)load{
    [self regiestDB];
}

//主键ID
+ (NSString *)db_pk{
    return @"primaryID";
}

//创建数据
+ (NSMutableArray<DHomeModel *> *)createData{
    NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<50; i++) {
        DHomeModel*homeModel=[DHomeModel crateModel];
        homeModel.homeTitle=Localized(@"Home2");
        homeModel.stateType=kStateWaiting;
        homeModel.downID=[NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000];
        [homeModel save:nil];
        [array addObject:homeModel];
    }
    return array;
}

//重置
-(void)reset{
    
    self.homeTitle=Localized(@"Home2");
    self.stateType=kStateWaiting;
    self.downID=[NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000];
    self.ico=@"";
    self.completeProportion=0;
    self.stateType=kStateWaiting;
    [self save:nil];
    
}









@end
