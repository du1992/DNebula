//
//  TODBPointerChecker.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "TODBPointerChecker.h"

@implementation TODBPointerChecker

+ (instancetype)checkerWithPointer:(TODBPointer *)pointer target:(NSObject *)target key:(NSString *)key{
    TODBPointerChecker *result = [[self alloc] init];
    if (result) {
        result.target = target;
        result.key = key;
        result.pointer = pointer;
    }
    return result;
}

@end
