//
//  NSObject+Property.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define TODBSearchCallback void(^)(NSArray *result)
#define TODBSearchCallback_(v) void(^v)(NSArray *result)

@interface NSObject (Property)

@property (nonatomic,assign) NSUInteger pk;

+ (NSMutableString *)db_sqlUpdateStr;
+ (NSMutableArray *)db_sqlUpdateObjs;

+ (void)addSearch:(NSString *)value forKey:(NSString *)key callback:(TODBSearchCallback)callback;
+ (void)searchKey:(NSString *)key make:(nonnull NSDictionary<NSString *,NSArray *> *(^)(NSArray<NSString *> *))block;

@end

NS_ASSUME_NONNULL_END
