//
//  TODBNotCondition.m
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBNotCondition.h"

@implementation TODBNotCondition

- (instancetype)initConditionWith:(id<TODBConditionBase>)condition
{
    self = [self init];
    if (self) {
        self.condition = condition;
    }
    return self;
}

+ (instancetype)conditionWith:(id<TODBConditionBase>)condition
{
    return [[self alloc] initConditionWith:condition];
}

- (NSString *)conditionWithPropertys:(NSDictionary *)propertys
{
    return [NSString stringWithFormat:@"NOT (%@)",[self.condition conditionWithPropertys:propertys]];
}

@end
