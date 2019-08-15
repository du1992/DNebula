//
//  DBusiness.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN
@interface DBusiness : NSObject

/**
 *  成功回调
 */
typedef void (^NetWorkSuccBlock) (NSDictionary *responseObject);
/**
 *  失败回调
 */
typedef void (^NetWorkErrorBlock)(NSError* error);


/**
 * 获取单例
 */
+ (DBusiness*)sharedInstance;

/**
 * 网络请求
 */
+(void)networkRequestURL:(NSString*)url parameters:(id)parameters successful:(NetWorkSuccBlock )successful failure:(NetWorkErrorBlock)failure;

/**
 * 查看版本
 */
+(void)yp_checkoutUpdateAppVersion;
/**
 * 升级提示
 */
+(void)upgradePop:(NSString*)description;
/**
 * 任务删除提示
 */
+(void)homeDeletePop:(NSString*)description successful:(NetWorkSuccBlock )successful;
/**
 * 评价提示
 */
+(void)evaluationPop:(NSString*)description failure:(NetWorkErrorBlock)failure;

@end
NS_ASSUME_NONNULL_END
