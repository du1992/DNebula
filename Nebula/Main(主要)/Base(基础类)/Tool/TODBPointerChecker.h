//
//  TODBPointerChecker.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODBPointer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TODBPointerChecker : NSObject

@property (nonatomic,strong) NSObject *target;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) TODBPointer *pointer;

+ (instancetype)checkerWithPointer:(TODBPointer *)pointer target:(NSObject *)target key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
