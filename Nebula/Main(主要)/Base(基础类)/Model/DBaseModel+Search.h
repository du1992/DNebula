//
//  NSObject+Search.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODBCondition.h"

@interface NSObject (Search)

/**
找到所有模型数据库同步
 
 @return all models.
 */
+ (NSArray *)allModels;


/**
找到所有异步模型数据库。
 
 @param block finish callback.
 */
+ (void)allModels:(void(^)(NSArray<NSObject *> *models))block;

/**
 分页查找模型数据库
 startIndex 页数.
  totalCount 数量
 */
+ (void)selectFromStart:(NSInteger)startIndex
       totalCount:(NSInteger)totalCount models:(void(^)(NSArray<NSObject *> *models))block;

/**
 删除所有
  */
+ (void)removeAll:(void(^)(void))block;

/**
通过条件搜索模型数据库同步。
 
 @param condition search condition
 @return search result
 */
+ (NSArray *)search:(id<TODBConditionBase>)condition;

/**
 异步搜索模型数据库的条件。
 
 @param condition search condition
 @param block finish callback.
 */
+ (void)search:(id<TODBConditionBase>)condition callBack:(void(^)(NSArray<NSObject *> *models))block;
/**
 异步搜索模型数据库的条件(有分页)
  */
+ (void)search:(id<TODBConditionBase>)condition startIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount callBack:(void(^)(NSArray<NSObject *> *models))block;

/**
在数据库的SQL同步搜索模型
 
 @param sqlString search SQL
 @return search result
 */
+ (NSArray *)searchSQL:(NSString *)sqlString;

/**
异步搜索模型数据库的SQL
 
 @param sqlString search SQL
 @param block finish callback.
 */
+ (void)searchSQL:(NSString *)sqlString callBack:(void(^)(NSArray<NSObject *> *models))block;



@end
