//
//  DRecycleModel.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DRecycleModel.h"

@implementation DRecycleModel
+ (void)load{
    [self regiestDB];
}

//主键ID
+ (NSString *)db_pk{
    return @"primaryID";
}

-(void)saveModel:(DHomeModel*)model{
    
    self.homeTitle          =model.homeTitle;
    self.homeCover          =model.homeCover;
    self.stateType          =kStateOerdue;
    self.completeProportion =model.completeProportion;
    self.ico                =model.ico;
    self.downID             =model.downID;
    [self                   save:nil];
}
//重置
-(void)reset{
    
    self.homeTitle=@"未创建";
    self.stateType=kStateWaiting;
    self.downID=[NSString stringWithFormat:@"%.0f", [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000];
    self.ico=@"";
    self.completeProportion=0;
    self.stateType=kStateWaiting;
    [self save:nil];
    
}


@end
