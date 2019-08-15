//
//  TODBOrCondition.h
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBCondition.h"

@interface TODBOrCondition : NSObject<TODBConditionBase>

@property (nonatomic,strong) id<TODBConditionBase> condition1;
@property (nonatomic,strong) id<TODBConditionBase> condition2;

- (instancetype)initConditionWith:(id<TODBConditionBase>)condition1 or:(id<TODBConditionBase>)condition2;

+ (instancetype)conditionWith:(id<TODBConditionBase>)condition1 or:(id<TODBConditionBase>)condition2;

@end
