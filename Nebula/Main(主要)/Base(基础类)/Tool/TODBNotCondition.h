//
//  TODBNotCondition.h
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBCondition.h"

@interface TODBNotCondition: NSObject<TODBConditionBase>

@property (nonatomic,strong) id<TODBConditionBase> condition;

- (instancetype)initConditionWith:(id<TODBConditionBase>)condition;

+ (instancetype)conditionWith:(id<TODBConditionBase>)condition;


@end
