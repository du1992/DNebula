//
//  NSObject+RegiestDB.m
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "DBaseModel+TODBModel.h"
#import "DBaseModel+Cache.h"

#import <objc/runtime.h>
#import "TODBModelConfig.h"
#import "TODataTypeHelper.h"
#import "TODBPointer.h"
#import "TODBCondition.h"
#import "TODBModelError.h"
#import "NSObject+NSCoding.h"
#import "NSObject+Property.h"
#import "NSArray+CheckPointer.h"
#import "TODBPointerChecker.h"


static dispatch_queue_t sql_queue;
const char *sql_queue_label = "to_db_model.sql";


/**
 修复FMDB中的一个bug。释放FMResultSet对象时使用的线程与查询时不同，导致插入操作如果过于频繁可能导致崩溃
 */
@interface FMResultSet (release)

@end

@implementation FMResultSet (release)


+ (void)initialize{
    [super initialize];
    Method oldM  = class_getInstanceMethod(self, @selector(close));
    Method newM = class_getInstanceMethod(self, @selector(db_close));
    method_exchangeImplementations(oldM, newM);
}

- (void)db_close{
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), sql_queue_label) == 0){
        // do something in main thread
        [self db_close];
    } else {
        // do something in other thread
        dispatch_sync(sql_queue, ^{
             [self db_close];
        });
    }
}

@end


@implementation NSObject (RegiestDB)

static FMDatabase *database;
static NSMutableDictionary *registedDBs;



+ (BOOL)existDB{
    NSString *db_name = [self db_name];
    NSNumber *number = [registedDBs objectForKey:db_name];
    if (number) {
        return [number boolValue];
    }else{
        BOOL result = [self db_existTable];
        [registedDBs setObject:@(result) forKey:db_name];
        return result;
    }
}

+ (void)regiestDB{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registedDBs = [NSMutableDictionary dictionary];
        sql_queue = dispatch_queue_create(sql_queue_label, DISPATCH_QUEUE_SERIAL);
        dispatch_async(sql_queue, ^{
            database = [FMDatabase databaseWithPath:TO_MODEL_DATABASE_PATH];
            [database open];
            
            TO_MODEL_LOG(@"数据库路径:%@",TO_MODEL_DATABASE_PATH);
            
            Method oldM  = class_getInstanceMethod(self, @selector(setValue:forKey:));
            Method newM = class_getInstanceMethod(self, @selector(swap_setValue:forKey:));
            method_exchangeImplementations(oldM, newM);
        });
    });
    
    NSString *db_name = [self db_name];
    if (![db_name isEqualToString:@"TODBModel"]) {
        
        //为了屏蔽NSKVONotifying_类及其他未知的覆盖操作
        if ([db_name rangeOfString:@"_"].location != NSNotFound) {
            return;
        }
        
        NSDate *date = [NSDate date];
        [self db_updateTable];
        TO_MODEL_LOG(@"%@检查完成，用时%f",[self db_name],[[NSDate date] timeIntervalSinceDate:date]);
        [registedDBs setObject:@(YES) forKey:db_name];
    }else{
        [registedDBs setObject:@(NO) forKey:db_name];
    }
}

+ (id)crateModel{
    NSString *pkType = [self sqlPropertys][[self db_pk]];
    if (![pkType isEqual:DB_TYPE_INTEGER]) {
        [NSException raise:@"创建模型失败" format:@"主键必须为int型"];
    }
    
    
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (NULL);",[[self class] db_name],[[self class] db_pk]];
    
    __block id result;
    
    
    dispatch_sync(sql_queue, ^{
        BOOL isSuccess = [database executeUpdate:sql];
        
        if (isSuccess) {
            //            TO_MODEL_LOG(@"数据库查询成功");
            
            result = [[self alloc] init];
            [result setValue:@(database.lastInsertRowId) forKey:[self db_pk]];
            
        }else{
            TO_MODEL_LOG(@"创建模型失败");
            TO_MODEL_LOG(@"%@",sql);
        }
        
        
        
    });
    
    return result;
}

+ (NSArray *)crateModels:(NSUInteger)count{
    
    NSString *pkType = [self sqlPropertys][[self db_pk]];
    if (![pkType isEqual:DB_TYPE_INTEGER]) {
        [NSException raise:@"创建模型失败" format:@"主键必须为int型"];
    }
    
    if (count == 0) {
        return @[];
    }
    __block int64_t lastID;
    
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ",[[self class] db_name],[[self class] db_pk]];
    
    
    for (int i=0; i<count; i++) {
        if (i == 0) {
            [sql appendString:@"(NULL)"];
            
        }else{
            [sql appendString:@",(NULL)"];
        }
    }
    
    dispatch_sync(sql_queue, ^{
        [database beginTransaction];
        BOOL isRollBack;
        @try
        {
            BOOL isSuccess = [database executeUpdate:sql];
            
            if (isSuccess) {
                //            TO_MODEL_LOG(@"数据库查询成功");
                
                lastID = database.lastInsertRowId;
                
            }else{
                TO_MODEL_LOG(@"创建模型失败");
                TO_MODEL_LOG(@"%@",sql);
            }
            
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [database rollback];
        }
        @finally
        {
            if (!isRollBack)
            {
                [database commit];
            }
        }
        
    });
    
    NSMutableArray *result = [NSMutableArray array];
    
    if (lastID != 0) {
        for (NSInteger i=count-1; i>=0; i--) {
            NSObject *model = [[self alloc] init];
            [model setValue:@(lastID - i) forKey:[self db_pk]];
            [result addObject:model];
        }
    }
    
    return result;
}


+ (void)crateModels:(NSUInteger)count callback:(void(^)(NSArray *models,NSError *error))block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *pkType = [self sqlPropertys][[self db_pk]];
        if (![pkType isEqual:DB_TYPE_INTEGER]) {
            
            if (block) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"主键必须为int型"                                                                      forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:TODBModelError code:TODBModelPrivateKeyError userInfo:userInfo];
                
                block(nil,error);
            }
            return;
        }
        
        if (count == 0) {
            if (block) {
                block(@[],nil);
            }
            return;
        }
        __block int64_t lastID;
        
        __block NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ",[[self class] db_name],[[self class] db_pk]];
        
        
        for (int i=0; i<count; i++) {
            if (i == 0) {
                [sql appendString:@"(NULL)"];
                
            }else{
                [sql appendString:@",(NULL)"];
            }
        }
        dispatch_sync(sql_queue, ^{

            [database beginTransaction];
            BOOL isRollBack;
            @try
            {
                __block BOOL isSuccess;
                isSuccess = [database executeUpdate:sql];
                
                
                if (isSuccess) {
                    //            TO_MODEL_LOG(@"数据库查询成功");
                    
                    lastID = database.lastInsertRowId;
                    
                }else{
                    TO_MODEL_LOG(@"创建模型失败");
                    TO_MODEL_LOG(@"%@",sql);
                }
                
            }
            @catch (NSException *exception)
            {
                isRollBack = YES;
                [database rollback];
            }
            @finally
            {
                if (!isRollBack)
                {
                    [database commit];
                }
            }
        });

        
        NSMutableArray *result = [NSMutableArray array];
        
        if (lastID != 0) {
            for (NSInteger i=count-1; i>=0; i--) {
                NSObject *model = [[self alloc] init];
                [model setValue:@(lastID - i) forKey:[self db_pk]];
                [result addObject:model];
            }
        }
        
        if (block) {
            block(result,nil);
        }
    });
}

- (void)save{
    [self db_update];
}

- (void)save:(void (^)(NSObject *))block{
    if ([[self class] existDB]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self db_update];
            if (block) {
                block(self);
            }
        });
    }
    
}

- (void)del{
    [self db_delete];
}

- (void)del:(void(^)(NSObject *model))block{
    __weak NSObject *self_weak = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       __strong NSObject *self_strong = self_weak;
        [self_strong db_delete];
        if (block) {
            block(self_strong);
        }
    });
}

#pragma mark - TODataBase
//检查并更新数据结构
+ (void)db_updateTable{
    if ([self db_existTable]) {
        NSMutableDictionary *colums;
        
        int result = [self checkTable:&colums];
        
        switch (result) {
            case 1:
            {
                for (NSString *name in colums.allKeys) {
                    [self addColumn:name withType:colums[name]];
                }
                break;
            }
            case 2:
            {
                NSString *tempTable = [self tempTable];
                [self createTable];
                [self copyTableFrom:tempTable toTable:[self db_name] colums:colums.allKeys];
                [self dropTable:tempTable];
            }
                break;
                
            default:
                break;
        }
    }else{
        [self createTable];
    }
}

+ (BOOL)db_existTable{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",[self db_name]];
    
    __block int totalCount = 0;
    dispatch_sync(sql_queue, ^{
        FMResultSet *result = [database executeQuery:sql];
        if ([result next]) {
            totalCount = [result intForColumnIndex:0];
        }
    });
    if (totalCount > 0) {
        return YES;
    }else{
        return NO;
    }
}


//删除数据库
+ (BOOL)db_dropTable{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@;",[self db_name]];
    __block BOOL result;
    dispatch_sync(sql_queue, ^{
        result = [database executeUpdate:sql];
    });
    
    return result;
}

//数据插入操作
- (void)db_update{
    
    NSString *pk = [[self class] db_pk];
    NSString *pv = [self valueForKey:pk];
    
    if (!pv) {
        NSException *e = [NSException
                          
                          exceptionWithName: @"数据插入错误"
                          
                          reason: @"主键不能为空"
                          
                          userInfo: nil];
        
        @throw e;
    }
    
    NSMutableString *columnName = [NSMutableString string];
    NSMutableString *columnValue = [NSMutableString string];
    NSMutableArray *arguments = [NSMutableArray array];

    
    NSDictionary *sqlPropertys = [[self class] sqlPropertys];
    
    for (NSString *key in sqlPropertys.allKeys) {
        id value = [self valueForKey:key];
        NSString *type = sqlPropertys[key];
        [columnName appendFormat:@"%@,",key];
        [columnValue appendFormat:@"%@,",[TODataTypeHelper objcObjectToSqlObject:value withType:type arguments:arguments]];
        if ([type isEqualToString:DB_TYPE_BLOB]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [value save:nil];

            });
        }
    }
    
    
    if ([columnName characterAtIndex:columnName.length - 1] == ',') {
        [columnName replaceCharactersInRange:NSMakeRange(columnName.length - 1,1) withString:@""];
    }
    if ([columnValue characterAtIndex:columnValue.length - 1] == ',') {
        [columnValue replaceCharactersInRange:NSMakeRange(columnValue.length - 1,1) withString:@""];
    }
    
    NSMutableString *sqlStr = [[self class] db_sqlUpdateStr];
    NSMutableArray *sqlArguments = [[self class] db_sqlUpdateObjs];

    static NSLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSLock new];
    });
    

    [lock lock];
    if ([sqlStr length] > 0) {
        [sqlStr appendString:[NSString stringWithFormat:@",(%@)",columnValue]];
        [sqlArguments addObjectsFromArray:arguments];
    }else{
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES (%@)",[[self class] db_name],columnName,columnValue];
        [sqlStr appendString:sql];
        [sqlArguments removeAllObjects];
        [sqlArguments addObjectsFromArray:arguments];

        dispatch_async(sql_queue, ^{
            NSString *__sqlStr;
            NSArray *__sqlArguments;
            [lock lock];
            __sqlStr = [sqlStr copy];
            __sqlArguments = [sqlArguments copy];
            
            [sqlArguments removeAllObjects];
            [sqlStr setString:@""];
            [lock unlock];

            NSInteger num = [database executeUpdate:__sqlStr withArgumentsInArray:__sqlArguments];
            if (num != 0) {
                
            }else{
                TO_MODEL_LOG(@"数据库更新失败");
                TO_MODEL_LOG(@"%@",__sqlStr);
            }
        });
    }
    [lock unlock];
}



//删除数据库内容
- (void)db_delete{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE %@ = \"%@\"",[[self class] db_name],[[self class] db_pk],[self valueForKey:[[self class] db_pk]]];
    
    
    
    dispatch_async(sql_queue, ^{
        BOOL result = [database executeUpdate:sql];
        
        if (result) {
            //            TO_MODEL_LOG(@"数据库删除成功");
        }else{
            TO_MODEL_LOG(@"数据库删除失败");
            TO_MODEL_LOG(@"%@",sql);
        }
        
    });
    
    
}

//放弃内存数据，从数据库重新读取
- (void)db_rollback{
    
}
//删除内存与数据库内容
- (void)db_destory{
    
}

//主键
+ (NSString *)db_pk{
    return @"pk";
}

//查找对象
+ (NSArray *)db_search:(id)value forKey:(NSString *)key{
    __block NSArray *searchResult;
    [self addSearch:value forKey:key callback:^(NSArray * _Nonnull result) {
        searchResult = result;
    }];
    [self searchKey:key make:^NSDictionary<NSString *,NSArray *> * _Nonnull(NSArray<NSString *> * values) {
        return [self db_searchValues:values forKey:key];
    }];
    
    return searchResult;
//
//    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ",[self db_name],key];
//    NSMutableArray *result = [NSMutableArray array];
//    NSMutableArray *arguments = [NSMutableArray array];
//    NSString *valueStr = [TODataTypeHelper objcObjectToSqlObject:value withType:[self sqlPropertys][key] arguments:arguments];
//
//    [sql appendString:valueStr];
//
//    dispatch_sync(sql_queue, ^{
//        FMResultSet *resultSet = [database executeQuery:sql withArgumentsInArray:arguments];
//
//        if (resultSet) {
//            //            TO_MODEL_LOG(@"数据库查询成功");
//        }else{
//            TO_MODEL_LOG(@"数据库查询失败");
//            TO_MODEL_LOG(@"%@",sql);
//        }
//
//
//        NSDictionary *classPropertys = [self classPropertys];
//        while ([resultSet next]) {
//            id item = [[self alloc] init];
//            int count = resultSet.columnCount;
//            for (int i=0; i<count; i++) {
//                NSString *key = [resultSet columnNameForIndex:i];
//                NSString *type = classPropertys[key];
//                if (key) {
//                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
//                    if (value) {
//                        [item setValue:value forKey:key];
//                    }
//                }
//            }
//
//            [result addObject:item];
//        }
//
//        [resultSet close];
//    });
//
//    [result checkPointer];
//
//    return result;
}

+ (NSDictionary<NSString *,NSArray *> *)db_searchValues:(NSArray<NSString *> *)values forKey:(NSString *)key{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    //生成SQL
    NSMutableArray *arguments = [NSMutableArray array];
    NSMutableString *valuesStr = [NSMutableString string];
    
    for (NSString *value in values) {
        if ([valuesStr length] > 0) {
            [valuesStr appendString:@" , "];
        }
        [valuesStr appendString: [TODataTypeHelper objcObjectToSqlObject:value withType:[self sqlPropertys][key] arguments:arguments]];
    }
    
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ IN (%@)",[self db_name], key, valuesStr];
    
    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = [database executeQuery:sql withArgumentsInArray:arguments];
        
        if (resultSet) {
            //            TO_MODEL_LOG(@"数据库查询成功");
        }else{
            TO_MODEL_LOG(@"数据库查询失败");
            TO_MODEL_LOG(@"%@",sql);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        while ([resultSet next]) {
            id item = [[self alloc] init];
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    if (value) {
                        [item setValue:value forKey:key];
                    }
                }
            }
            
            id value = [item valueForKey:key];
            NSMutableArray *arr = [result objectForKey:value];
            if (!arr) {
                arr = [NSMutableArray array];
                [result setObject:arr forKey:value];
            }
            [arr addObject:item];
        }
        
        [resultSet close];
    });
    
    for (NSArray *arr in result.allValues) {
        [arr checkPointer];
    }
    
    return result;
}
+ (NSArray *)db_condition_search:(id<TODBConditionBase>)condition startIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",[self db_name]];
    [sql appendString:[condition conditionWithPropertys:[self sqlPropertys]]];
    
    if (0 == startIndex) {
       
        
//        sql=[NSMutableString stringWithFormat:@"SELECT * FROM %@ ORDER BY primaryID DESC LIMIT ? " ,[self db_name]];
    }else{
//        sql =[NSMutableString stringWithFormat:@"SELECT * FROM %@ where primaryID < ? ORDER BY primaryID DESC LIMIT ? " ,[self db_name]];
    }
    NSMutableArray *result = [NSMutableArray array];
//    NSMutableArray *arguments = [NSMutableArray array];
    
    
    
    
    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = nil;
        if (0 == startIndex) {
             [sql appendString:@"ORDER BY primaryID DESC LIMIT ? "];
            resultSet=[database executeQuery:sql, @(totalCount)];
            
        } else {
             [sql appendString:@" and primaryID < ? ORDER BY primaryID DESC LIMIT ? "];
            resultSet=[database executeQuery:sql,@(startIndex), @(totalCount)];
            
        }
        if (resultSet) {
            //            TO_MODEL_LOG(@"数据库查询成功");
        }else{
            TO_MODEL_LOG(@"数据库查询失败");
            TO_MODEL_LOG(@"%@",sql);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        while ([resultSet next]) {
            id item = [[self alloc] init];
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    if (value) {
                        [item setValue:value forKey:key];
                    }
                }
            }
            
            [result addObject:item];
        }
        [resultSet close];
        
    });
    
    [result checkPointer];
    
    return result;
    
    
}
+ (NSArray *)db_condition_search:(id<TODBConditionBase>)condition{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",[self db_name]];
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *arguments = [NSMutableArray array];
    
    [sql appendString:[condition conditionWithPropertys:[self sqlPropertys]]];
    
    
    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = [database executeQuery:sql withArgumentsInArray:arguments];
        
        if (resultSet) {
            //            TO_MODEL_LOG(@"数据库查询成功");
        }else{
            TO_MODEL_LOG(@"数据库查询失败");
            TO_MODEL_LOG(@"%@",sql);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        while ([resultSet next]) {
            id item = [[self alloc] init];
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    if (value) {
                        [item setValue:value forKey:key];
                    }
                }
            }
            
            [result addObject:item];
        }
        [resultSet close];
        
    });
    
    [result checkPointer];
    
    return result;
}
+ (NSArray *)db_search:(NSString *)sqlStr startIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount{
    __block NSDate *date = [NSDate new];
    
    NSMutableArray *dicList = [NSMutableArray array];
    
    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = nil;
        if (0 == startIndex) {
           resultSet=[database executeQuery:sqlStr, @(totalCount)];
      
        } else {
            resultSet=[database executeQuery:sqlStr,@(startIndex), @(totalCount)];
            
        }
        
        if (resultSet) {
            //            TO_MODEL_LOG(@"数据库查询成功");
        }else{
            TO_MODEL_LOG(@"数据库查询失败");
            TO_MODEL_LOG(@"%@",sqlStr);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        date = [NSDate date];
        while ([resultSet next]) {
            [dic removeAllObjects];
            
            
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    if (value) {
                        [dic setObject:value forKey:key];
                    }
                }
            }
            
            [dicList addObject:[dic copy]];
        }
        [resultSet close];
    });
    
    date = [NSDate date];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *dic in dicList) {
        
        id pkValue = dic[[self db_pk]];
        NSObject *model = [self memoryByKey:pkValue];
        if (!model) {
            model = [self modelByDic:dic];
        }
        
        [result addObject:model];
    }
    [result checkPointer];
    return result;
}

+ (NSArray *)db_search:(NSString *)sqlStr{
    __block NSDate *date = [NSDate new];

    NSMutableArray *dicList = [NSMutableArray array];

    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = [database executeQuery:sqlStr];
        if (resultSet) {
            //            TO_MODEL_LOG(@"数据库查询成功");
        }else{
            TO_MODEL_LOG(@"数据库查询失败");
            TO_MODEL_LOG(@"%@",sqlStr);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        date = [NSDate date];
        while ([resultSet next]) {
            [dic removeAllObjects];
            
            
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    if (value) {
                        [dic setObject:value forKey:key];
                    }
                }
            }
            
            [dicList addObject:[dic copy]];
        }
        [resultSet close];
    });
    
    date = [NSDate date];

    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *dic in dicList) {
        
        id pkValue = dic[[self db_pk]];
        NSObject *model = [self memoryByKey:pkValue];
        if (!model) {
            model = [self modelByDic:dic];
        }
        
        [result addObject:model];
    }
    [result checkPointer];
    return result;
}

//数据库名称
+ (NSString *)db_name{
    return [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] lastObject];
}


#pragma mark - Private
- (void)db_checkPointer:(void(^)(TODBPointerChecker *checker))block{
    NSDictionary *dic = [[self class] classPropertys];

    for (NSString *key in dic.allKeys) {
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[TODBPointer class]]) {
            if (block) {
                block([TODBPointerChecker checkerWithPointer:value target:self key:key]);
            }
//            value = [(TODBPointer *)value model];
        }
    }
}


//- (void)db_checkPointer{
//    NSDictionary *dic = [[self class] classPropertys];
//
//    for (NSString *key in dic.allKeys) {
//        id value = [self valueForKey:key];
//        if ([value isKindOfClass:[TODBPointer class]]) {
//            value = [(TODBPointer *)value model];
//        }
//
//        [self setValue:value forKey:key];
//    }
//}

//插入字段
+ (void)addColumn:(NSString *)name withType:(NSString *)type{
    __block NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@;",[self db_name],name,type];
    
    dispatch_async(sql_queue, ^{
        if ([database executeUpdate:sql]) {
            //            TO_MODEL_LOG(@"添加字段成功");
            
        }else{
            TO_MODEL_LOG(@"添加表字段失败");
            TO_MODEL_LOG(@"%@",sql);
        }
    });
}

//检查字段
//0不更新、1添加缺省字段、2删除重建
+ (int)checkTable:(NSMutableDictionary **)colums{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"PRAGMA TABLE_INFO (\"%@\");",[self db_name]];
    
    NSMutableDictionary *lostColums = [NSMutableDictionary dictionary];
    NSMutableDictionary *sameColums = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *tablePropertys = [NSMutableDictionary dictionary];
    dispatch_sync(sql_queue, ^{
        
        FMResultSet *result = [database executeQuery:sql];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            NSString *type = [result stringForColumn:@"type"];
            
            tablePropertys[name] = type;
        }
    });
    
    NSDictionary *sqlPropertys = [self sqlPropertys];
    
    
    int result=0;
    
    for (NSString *name in sqlPropertys.allKeys) {
        if (tablePropertys[name]) {
            [sameColums setObject:sqlPropertys[name] forKey:name];
            
            //字段已存在时，检查字段是否一样
            if ([tablePropertys[name] rangeOfString:sqlPropertys[name]].location != 0) {
                result = 2;
            }
        }else{
            if (result == 2) {
                continue;
            }
            result = 1;
            //字段不存在时，添加字段
            NSMutableDictionary *dic = lostColums;
            if (dic) {
                [dic setObject:sqlPropertys[name] forKey:name];
            }
        }
    }
    
    if (result == 2) {
        *colums = sameColums;
    }else if(result == 1){
        *colums = lostColums;
    }
    
    return result;
}

//复制table到临时table
+ (NSString *)tempTable{
    NSString *tempName = [NSString stringWithFormat:@"%@_%d",[self db_name],rand()];
    __block NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@;",[self db_name],tempName];
    
    
    dispatch_sync(sql_queue, ^{
        
        if ([database executeUpdate:sql]){
            //            TO_MODEL_LOG(@"表重命名成功");
        }else{
            TO_MODEL_LOG(@"表重命名失败");
            TO_MODEL_LOG(@"%@",sql);
        }
    });
    
    
    return tempName;
}

//拷贝表
+ (void)copyTableFrom:(NSString *)table1 toTable:(NSString *)table2 colums:(NSArray<NSString *> *)colums{
    NSString *columStr = [colums componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( %@ ) SELECT %@ FROM %@;",table2 , columStr ,columStr, table1];
    dispatch_sync(sql_queue, ^{
        
        if ([database executeUpdate:sql]){
            //            TO_MODEL_LOG(@"拷贝表成功");
        }else{
            TO_MODEL_LOG(@"拷贝表失败");
            TO_MODEL_LOG(@"%@",sql);
        }
    });
}

//创建table
+ (void)createTable{
    __block NSString *sql = [self createTableSQL];
    
    dispatch_sync(sql_queue, ^{
        if ([database executeUpdate:sql]){
            //            TO_MODEL_LOG(@"数据表创建成功");
        }else{
            TO_MODEL_LOG(@"数据表创建失败");
            TO_MODEL_LOG(@"%@",sql);
        }
    });
}
//删除table
+ (void)dropTable:(NSString *)tableName{
   
    
    __block NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@;",tableName];
    
    dispatch_sync(sql_queue, ^{
        if ([database executeUpdate:sql]){
            //            TO_MODEL_LOG(@"删除数据表成功");
        }else{
            TO_MODEL_LOG(@"删除数据表失败");
            TO_MODEL_LOG(@"%@",sql);
        }
    });
}

//创建table的SQL
+ (NSString *)createTableSQL{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (",[self db_name]];
    
    NSDictionary *dic = [self sqlPropertys];
    for (NSString *name in dic.allKeys) {
        if ([name isEqualToString:[self db_pk]]) {
            [sql appendFormat:@"%@ %@ PRIMARY KEY NOT NULL,",name,dic[name]];
        }else{
            [sql appendFormat:@"%@ %@,",name,dic[name]];
        }
    }
    if ([sql characterAtIndex:sql.length - 1] == ',') {
        [sql replaceCharactersInRange:NSMakeRange(sql.length - 1,1) withString:@""];
    }
    //    [sql appendFormat:@"PRIMARY KEY (%@)",[self db_pk]];
    [sql appendString:@")"];
    
    return sql;
}

//objc属性名与sql属性的对应关系
+ (NSDictionary *)sqlPropertys{
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, __func__);
    
    if (dic) {
        return dic;
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        
        objc_property_t property = propertys[i];
        
        const char *name = property_getName(property);
        
        const char *type = property_copyAttributeValue(property,"T");
        
        NSString *sqlTypeName = objcType2SqlType(type);
        if (!sqlTypeName) {
            TO_MODEL_LOG(@"#TOModel# %@中存在未识别的数据类型%s",NSStringFromClass([self class]),type);
        }else{
            if ([sqlTypeName isEqualToString:DB_TYPE_BLOB]) {
                NSString *regex = @"^@\"[a-zA-Z_0-9]+\"$";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                
                NSString *typeName = [NSString stringWithUTF8String:type];
                if ([predicate evaluateWithObject:typeName]) {
                    typeName = [typeName substringWithRange:NSMakeRange(2, typeName.length - 3)];
                    Class typeClass = NSClassFromString(typeName);
                    if (typeClass) {
                        [typeClass db_registNSCoding];
                    }
                }
            }
            [dic setObject:sqlTypeName forKey:[NSString stringWithUTF8String:name]];
        }
        
    }
    free(propertys);
    NSString *pk = [self db_pk];
    if (![dic objectForKey:pk]) {
        [dic setObject:DB_TYPE_INTEGER forKey:pk];
    }
    
    objc_setAssociatedObject(self, __func__, dic, OBJC_ASSOCIATION_COPY);
    
    return dic;
}


//本地属性与类型名称的对应关系
+ (NSDictionary *)classPropertys{
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, __func__);
    
    if (dic) {
        return dic;
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        
        objc_property_t property = propertys[i];
        
        const char *name = property_getName(property);
        
        const char *type = property_copyAttributeValue(property,"T");
        
        
        NSString *sqlTypeName = [NSString stringWithUTF8String:type];
        
        if (!sqlTypeName) {
            TO_MODEL_LOG(@"#TOModel# %@中存在未识别的数据类型%s",NSStringFromClass([self class]),type);
        }else{
            [dic setObject:sqlTypeName forKey:[NSString stringWithUTF8String:name]];
        }
    }
    
    NSString *pk = [self db_pk];
    if (![dic objectForKey:pk]) {
        [dic setObject:@"@\"NSString\"" forKey:pk];
    }
    
    objc_setAssociatedObject(self, __func__, dic, OBJC_ASSOCIATION_COPY);
    
    return dic;
}

//update model indexes in memory
+ (void)saveModelByKey:(nonnull id)modelKey model:(nonnull NSObject *)model{
    //This method is realizd in category of NSObject+Cache
}

#pragma mark - KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"pk"]) {
        [self setPk:[[NSString stringWithFormat:@"%@",value] integerValue]];
    }
}

- (void)swap_setValue:(id)value forKey:(NSString *)key{
    @try {
        [self swap_setValue:value forKey:key];
    } @catch (NSException *exception) {
        if (!key) {
            @throw exception;
        }else{
            [self setValue:value forUndefinedKey:key];
        }
    } @finally {
        
    }
    
    if ([key isEqualToString:[[self class] db_pk]]) {
        [[self class] saveModelByKey:value model:self];
    }
}

- (id)valueForUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"pk"]) {
        return @([self pk]);
    }else{
        return nil;
    }
}


@end
