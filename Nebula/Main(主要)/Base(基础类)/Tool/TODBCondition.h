//
//  TODBCondition.h
//  TODBModel
//
//  Created by Tony on 17/2/3.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TODBConditionBase

@required
- (NSString *)conditionWithPropertys:(NSDictionary *)propertys;

@end




@interface TODBCondition: NSObject<TODBConditionBase>

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) id value;
@property (nonatomic,copy) NSString *relationship;


+ (TODBCondition *)condition:(NSString *)key equalTo:(id)value;
+ (TODBCondition *)condition:(NSString *)key like:(NSString *)value;


+ (TODBCondition *)condition:(NSString *)key greaterThan:(id)value;
+ (TODBCondition *)condition:(NSString *)key greaterOrEqualThan:(id)value;
+ (TODBCondition *)condition:(NSString *)key lessThan:(id)value;
+ (TODBCondition *)condition:(NSString *)key lessOrEqualThan:(id)value;




@end
