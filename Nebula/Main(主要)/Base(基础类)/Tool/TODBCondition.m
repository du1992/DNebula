//
//  TODBCondition.m
//  TODBModel
//
//  Created by Tony on 17/2/3.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBCondition.h"
#import "TODataTypeHelper.h"

@implementation TODBCondition

- (id)initWithKey:(NSString *)key value:(id)value relationship:(NSString *)relationship{
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
        self.relationship = relationship;
    }
    return self;
}


+ (TODBCondition *)condition:(NSString *)key equalTo:(id)value{
    return [[self alloc] initWithKey:key value:value relationship:@"="];
}
+ (TODBCondition *)condition:(NSString *)key like:(NSString *)value{
    return [[self alloc] initWithKey:key value:value relationship:@"like"];
}


+ (TODBCondition *)condition:(NSString *)key greaterThan:(id)value{
    return [[self alloc] initWithKey:key value:value relationship:@">"];
}
+ (TODBCondition *)condition:(NSString *)key greaterOrEqualThan:(id)value{
    return [[self alloc] initWithKey:key value:value relationship:@">="];
}
+ (TODBCondition *)condition:(NSString *)key lessThan:(id)value{
    return [[self alloc] initWithKey:key value:value relationship:@"<"];
}
+ (TODBCondition *)condition:(NSString *)key lessOrEqualThan:(id)value{
    return [[self alloc] initWithKey:key value:value relationship:@"<="];
}

#pragma mark - <TODBConditionBase>
- (NSString *)conditionWithPropertys:(NSDictionary *)propertys{
    NSString *valueStr = [TODataTypeHelper objcObjectToSqlObject:self.value withType:propertys[self.key] arguments:nil];
    return [NSString stringWithFormat:@"%@ %@ %@",self.key,self.relationship,valueStr];
}
@end
