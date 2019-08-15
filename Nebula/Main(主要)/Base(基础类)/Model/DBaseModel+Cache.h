//
//  NSObject+Cache.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
这一类将帮助您从内存或数据库搜索模型
 */
@interface NSObject (Cache)


/**
用这种方法你可以找到/创建一个模型。
 1.If a model with same Primary Key in memory. The method will update and return it.
 2.If a model with same Primary Key in database. The method will create a model form database. Update the model and return it.
 3.Otherwise, the method will create a empty model. Update the model and return it.
 
 @param dic rarams which will update to model
 @return result of TODBModel
 */
+ (nonnull instancetype)modelByDic:(nonnull NSDictionary *)dic;


/**
搜索你的记忆,找到一个模型与主键。
 
 @param modelKey Primary Key
 @return result
 */
+ (nullable instancetype)memoryByKey:(nonnull id)modelKey;

+ (NSDictionary *_Nullable)modelsByKeys:(NSArray *_Nonnull)modelKeys;

/**
 搜索内存/数据库并返回模型相同的主键。如果发现任何模型,返回在内存中创建一个模型与主键和返回它。
 
 @param modelKey Primary Key
 @return result
 */
+ (nonnull instancetype)modelByKey:(nonnull id)modelKey;


/**
指-modelByKey:。如果没有allowNull,-modelByKey:相同。否则可能会返回零。
 
 @param modelKey Primary Key
 @param allowNull allows nil return
 @return result
 */
+ (nullable instancetype)modelByKey:(nonnull id)modelKey allowNull:(BOOL)allowNull;


@end
