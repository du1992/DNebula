//
//  NSObject+Property.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>



@interface NSObject ()

+ (NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,NSMutableSet<TODBSearchCallback> *> *> *)db_sqlSearchObjs;

@end

@implementation NSObject (Property)


- (NSUInteger)pk{
    return [objc_getAssociatedObject(self, @"NSObject_pk") unsignedIntegerValue];
}

- (void)setPk:(NSUInteger)pk{
    objc_setAssociatedObject(self, @"NSObject_pk", [NSNumber numberWithUnsignedInteger:pk], OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableString *)db_sqlUpdateStr{
    static NSMutableDictionary *sqlClassDic;
    static NSLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlClassDic = [NSMutableDictionary dictionary];
        lock = [NSLock new];
    });
    
    [lock lock];
    NSMutableString *sqlStr = [sqlClassDic objectForKey:NSStringFromClass(self)];
    if (!sqlStr) {
        sqlStr = [NSMutableString string];
        [sqlClassDic setObject:sqlStr forKey:NSStringFromClass(self)];
    }
    [lock unlock];
    return sqlStr;
}

+ (NSMutableArray *)db_sqlUpdateObjs{
    static NSMutableDictionary *sqlClassDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlClassDic = [NSMutableDictionary dictionary];
    });
    
    NSMutableArray *sqlObjs = [sqlClassDic objectForKey:NSStringFromClass(self)];
    if (!sqlObjs) {
        sqlObjs = [NSMutableArray array];
        [sqlClassDic setObject:sqlObjs forKey:NSStringFromClass(self)];
    }
    return sqlObjs;
}

+ (NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,NSMutableSet *> *> *)db_sqlSearchObjs{
    static NSMutableDictionary *sqlClassDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlClassDic = [NSMutableDictionary dictionary];
    });
    
    NSMutableDictionary *sqlObjs = [sqlClassDic objectForKey:NSStringFromClass(self)];
    if (!sqlObjs) {
        sqlObjs = [NSMutableDictionary dictionary];
        [sqlClassDic setObject:sqlObjs forKey:NSStringFromClass(self)];
    }
    return sqlObjs;
}

+ (NSMutableDictionary<NSString *,NSMutableSet *> *)db_sqlSearchValueForKey:(NSString *)key{
    NSMutableDictionary *result = [[self db_sqlSearchObjs] objectForKey:key];
    if (!result) {
        result = [NSMutableDictionary dictionary];
        [[self db_sqlSearchObjs] setObject:result forKey:key];
    }
    return result;
}

+ (NSMutableSet *)db_sqlSearchCallbacksForKey:(NSString *)key value:(NSString *)value{
    NSMutableDictionary<NSString *,NSMutableSet *> *dic = [self db_sqlSearchValueForKey:key];
    NSMutableSet *callbacks = [dic objectForKey:value];
    if (!callbacks) {
        callbacks = [NSMutableSet new];
        [dic setObject:callbacks forKey:value];
    }
    return callbacks;
}

+ (NSLock *)searchLock{
    static NSLock *_searchLock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _searchLock = [NSLock new];
    });
    return _searchLock;
}

+ (void)clearSearchForKey:(NSString *)key{
    [[self db_sqlSearchObjs] removeObjectForKey:key];
}

+ (void)addSearch:(NSString *)value forKey:(NSString *)key callback:(TODBSearchCallback)callback{
//    [[self searchLock] lock];
    NSMutableSet *callbacks = [self db_sqlSearchCallbacksForKey:key value:value];
    [callbacks addObject:callback];
//    [[self searchLock] unlock];
}

+ (void)searchKey:(NSString *)key make:(nonnull NSDictionary<NSString *,NSArray *> *(^)(NSArray<NSString *> *))block{
//    [[self searchLock] lock];
    NSMutableDictionary<NSString *,NSMutableSet<TODBSearchCallback> *> *searchObj = [[self db_sqlSearchObjs] objectForKey:key];
    
    NSArray<NSString *> *values;
    if (searchObj) {
        [[self db_sqlSearchObjs] removeObjectForKey:key];
        values = [searchObj allKeys];
    }
    
//    [[self searchLock] unlock];
    if (block && values) {
        NSDictionary *searchResults = block(values);
        for (NSString *value in values) {
            for (TODBSearchCallback_(callback) in [searchObj objectForKey:value]) {
                callback([searchResults objectForKey:value]);
            }
        }
    }
}

@end
