//
//  TODBAndCondition.m
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBAndCondition.h"

@implementation TODBAndCondition

- (instancetype)initConditionWith:(id<TODBConditionBase>)condition1 and:(id<TODBConditionBase>)condition2
{
    self = [self init];
    if (self) {
        self.condition1 = condition1;
        self.condition2 = condition2;
    }
    return self;
}

+ (instancetype)conditionWith:(id<TODBConditionBase>)condition1 and:(id<TODBConditionBase>)condition2
{
    return [[self alloc] initConditionWith:condition1 and:condition2];
}

- (NSString *)conditionWithPropertys:(NSDictionary *)propertys
{
    return [NSString stringWithFormat:@"(%@) AND (%@)",[self.condition1 conditionWithPropertys:propertys],[self.condition2 conditionWithPropertys:propertys]];
}

@end
