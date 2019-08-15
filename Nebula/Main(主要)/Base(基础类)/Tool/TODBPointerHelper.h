//
//  TODBPointerHelper.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODBPointerChecker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TODBPointerHelper : NSObject

+ (void)addChecker:(TODBPointerChecker *)checker data:(NSMutableDictionary<NSString *, NSMutableSet<TODBPointerChecker *> *> *)data;
+ (NSDictionary<NSString *,NSSet<TODBPointerChecker *> *> *)groupByID:(NSSet<TODBPointerChecker *> *)checkers;

@end

NS_ASSUME_NONNULL_END
