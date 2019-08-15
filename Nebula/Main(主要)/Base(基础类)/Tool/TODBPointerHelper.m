//
//  TODBPointerHelper.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "TODBPointerHelper.h"

@implementation TODBPointerHelper

+ (void)addChecker:(TODBPointerChecker *)checker data:(NSMutableDictionary<NSString *, NSMutableSet<TODBPointerChecker *> *> *)data{
    NSString *className = checker.pointer.className;
    NSMutableSet *set = [data objectForKey:className];
    if (!set) {
        set = [NSMutableSet set];
        [data setObject:set forKey:className];
    }
    [set addObject:checker];
}

+ (NSDictionary<NSString *,NSSet<TODBPointerChecker *> *> *)groupByID:(NSSet<TODBPointerChecker *> *)checkers{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (TODBPointerChecker *checker in checkers) {
        TODBPointer *pointer = checker.pointer;
        NSMutableSet *set = [result objectForKey:pointer.pkValue];
        if (!set) {
            set = [NSMutableSet set];
            [result setObject:set forKey:pointer.pkValue];
        }
        [set addObject:checker];
    }
    return result;
}

@end
