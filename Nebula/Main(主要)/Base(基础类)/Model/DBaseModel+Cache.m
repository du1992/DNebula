//
//  NSObject+Cache.m
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "DBaseModel+Cache.h"
#import "DBaseModel+TODBModel.h"
#import "NSArray+CheckPointer.h"

@implementation NSObject (Cache)

static NSMapTable * cache;

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
    });
}

#pragma mark - Public
+ (id)modelByDic:(NSDictionary *)dic{
    NSString *pkValue = dic[[self db_pk]];
    
    NSObject *model = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),pkValue]];
    
    if (!model) {
        model = [[self alloc] init];
    }
    
    
    for (NSString *key in dic.allKeys) {
        [model setValue:dic[key] forKey:key];
    }
    return model;
}


+ (instancetype)memoryByKey:(id)modelKey{
    id result = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    return result;
}
//获取模型
+ (instancetype)modelByKey:(id)modelKey{
    return [self modelByKey:modelKey allowNull:NO];
}

//获取模型
+ (instancetype)modelByKey:(id)modelKey allowNull:(BOOL)allowNull{
    if (!modelKey) {
        if (allowNull) {
            return nil;
        }else{
            return [[self alloc] init];
        }
    }
    
    id result = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    if (!result) {
        result = [[self db_search:modelKey forKey:[self db_pk]] lastObject];
    }
    if ((!allowNull) && (!result)) {
        result = [[self alloc] init];
        
        [result setValue:modelKey forKey:[self db_pk]];
    }
    
    return result;
}

+ (NSDictionary *)modelsByKeys:(NSArray *)modelKeys{
    if (!modelKeys || [modelKeys count] == 0) {
        return @{};
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *searchKeys = [NSMutableArray array];
    for (NSString *modelKey in modelKeys) {
        id cachedModel = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
        if (cachedModel) {
            [result setObject:cachedModel forKey:modelKey];
        }else{
            [searchKeys addObject:modelKey];
        }
    }
    
    NSDictionary *searchedModel = [self db_searchValues:searchKeys forKey:[self db_pk]];
    NSMutableArray *modesNeedCheck = [NSMutableArray array];
    for (NSString *key in searchedModel.allKeys) {
        NSArray *values = [searchedModel objectForKey:key];
        id obj = [values lastObject];
        if (obj) {
            [result setObject:obj forKey:key];
            [modesNeedCheck addObject:obj];
        }
    }
    [modesNeedCheck checkPointer];
    return [result copy];
}

+ (void)saveModelByKey:(id)modelKey model:(NSObject *)model{
    if (modelKey) {
        [cache setObject:model forKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    }
}

@end
