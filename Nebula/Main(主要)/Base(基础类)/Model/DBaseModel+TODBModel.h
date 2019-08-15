//
//  NSObject+TODBModel.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODataBase.h"

@interface NSObject (RegiestDB)<TODataBase>

@property (nonatomic,assign) NSUInteger pk;


/**
 表在数据库存在吗
 */
+ (BOOL)existDB;

/**
为这个类创建或更新表
 */
+ (void)regiestDB;

/**
创建一个新的模型
 */
+ (id)crateModel;

/**
创建一个模型同步
 
 @param count create number.
 @return created models.
 */
+ (NSArray *)crateModels:(NSUInteger)count;

/**
创建一个模型异步
 
 @param count create number.
 */
+ (void)crateModels:(NSUInteger)count callback:(void(^)(NSArray *models,NSError *error))block;

/**
一个模型保存到数据库同步
 */
- (void)save;

/**
异步模型保存到数据库
 
 @param block finish callback.
 */
- (void)save:(void(^)(NSObject *model))block;

/**
删除一个模型与数据库同步
 */
- (void)del;

/**
删除一个模型与数据库同步.
 
 @param block finish callback.
 */
- (void)del:(void(^)(NSObject *model))block;


@end
