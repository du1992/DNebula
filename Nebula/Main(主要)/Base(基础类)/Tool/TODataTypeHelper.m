//
//  TODataTypeHelper.m
//  TODBModel
//
//  Created by Tony on 16/11/28.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODataTypeHelper.h"
#import "TODBPointer.h"
#import "DBaseModel+TODBModel.h"
#import "TODBModelConfig.h"

typedef enum : NSUInteger {
    TODataTypeUnknow,
    TODataTypeClass,
    TODataTypeNSString,
    TODataTypeNSDate,
    TODataTypeNSData,
} TODataType;

@implementation TODataTypeHelper

//将objc类型转化为Sqllite对应的类型
+ (NSString *)objcTypeToSqlType:(const char *)objcType{
    NSString *result = nil;
    
    NSString *type = [NSString stringWithUTF8String:objcType];
    NSString *regex = @"^@\"[a-zA-Z_0-9]+\"$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:type]) {
        if ([type isEqualToString:@"@\"NSString\""]) {
            result = DB_TYPE_TEXT;
        }else if([type isEqualToString:@"@\"NSDate\""]){
            result = DB_TYPE_INTEGER;
        }else{
            result = DB_TYPE_BLOB;
        }
    }else{
        char t = objcType[0];
        if (t == '^') {
            t = objcType[1];
        }
        
        switch (t) {
            case 'i':
            case 'I':
                result = DB_TYPE_INTEGER;
                break;
            case 'q':
            case 'Q':
            case 'd':
            case 'D':
                result = DB_TYPE_INTEGER;
                break;
            case 'f':
            case 'F':
                result = DB_TYPE_REAL;
                break;
            default:
                break;
        }
    }
    
    return result;
}


+ (NSString *)objcObjectToSqlObject:(id)objcObject withType:(NSString *)type arguments:(NSMutableArray *)arguments{
    
    NSString *result = nil;
    
    if ([type isEqualToString:DB_TYPE_BLOB]) {
        if ([objcObject isKindOfClass:[NSObject class]]) {
            if ([[objcObject class] existDB]) {
                objcObject = [[TODBPointer alloc] initWithModel:objcObject];
            }
        }
        
        if (!objcObject || [objcObject isEqual:[NSNull null]]) {
            result = DB_NULL;
        }else{
            result = @"?";
            if (arguments) {
                NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:objcObject];
                [arguments addObject:dataOnObject];
            }
        }
    }else{
        if (!objcObject || [objcObject isEqual:[NSNull null]]) {
            result = DB_NULL;
        }else{
            if ([type isEqualToString:DB_TYPE_TEXT]) {
                result = [NSString stringWithFormat:@"\"%@\"",objcObject];

            }else if([objcObject isKindOfClass:[NSDate class]]){
                result = [NSString stringWithFormat:@"%f",[(NSDate *)objcObject timeIntervalSince1970]];
            }else{
                result = [NSString stringWithFormat:@"%@",objcObject];
            }
        }
    }
    
    
    return result;
}

+ (void)typeFromString:(NSString *)objcType complete:(void(^)(TODataType type,Class customClass))complete{
    static NSMutableDictionary *typeDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDic = [NSMutableDictionary dictionary];
    });
    
    if (objcType) {
        NSDictionary *cachedTypeDic = [typeDic objectForKey:objcType];
        if (!cachedTypeDic) {
            NSString *regex = @"^@\"[a-zA-Z_0-9]+\"$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([predicate evaluateWithObject:objcType]) {
                if ([objcType isEqualToString:@"@\"NSString\""]) {
                    cachedTypeDic = @{@"type":@(TODataTypeNSString)};
                }else if ([objcType isEqualToString:@"@\"NSDate\""]) {
                    cachedTypeDic = @{@"type":@(TODataTypeNSDate)};

                }else if([objcType isEqualToString:@"@\"NSData\""]){
                    cachedTypeDic = @{@"type":@(TODataTypeNSData)};
                }else{
                    NSString *className = [objcType substringWithRange:NSMakeRange(2, objcType.length - 3)];
                    Class class = NSClassFromString(className);
                    cachedTypeDic = @{@"type":@(TODataTypeClass),@"class":class};
                }
            }else{
                cachedTypeDic = @{@"type":@(TODataTypeUnknow)};
            }
            
            [typeDic setObject:cachedTypeDic forKey:objcType];
        }
        
        
        if (complete) {
            TODataType type = [cachedTypeDic[@"type"] integerValue];
            if (type == TODataTypeClass) {
                complete(type,cachedTypeDic[@"class"]);
            }else{
                complete(type,nil);
            }
        }
    }
}

+ (id)readObjcObjectFrom:(FMResultSet *)resultSet name:(NSString *)name type:(NSString *)objcType{
    
    __block id result;
    
    [self typeFromString:objcType complete:^(TODataType type, __unsafe_unretained Class customClass) {
        switch (type) {
            case TODataTypeNSString:
                result = [resultSet stringForColumn:name];
                break;
            case TODataTypeNSDate:
            {
                NSTimeInterval timeInterval = [resultSet doubleForColumn:name];
                result = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            }
                break;
            case TODataTypeNSData:
                result = [result dataForColumn:name];
                break;
            case TODataTypeClass:
            {
                NSData *data = [resultSet dataForColumn:name];

                if ([customClass isSubclassOfClass:[NSObject class]]) {
                    
                    TODBPointer *pointer;
                    @try {
                        pointer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    }
                    @catch (NSException *exception) {
                    }
                    if (pointer && ![pointer isEqual:[NSNull null]]) {
                        result = pointer;
                    }
                }else{
                    @try {
                        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    }
                    @catch (NSException *exception) {
                        TO_MODEL_LOG(@"属性解析失败.\n%@",exception);
                    }
                }
            }
                break;
            case TODataTypeUnknow:
                result = @([resultSet doubleForColumn:name]);
                break;
            default:
                break;
        }
    }];
    
    return result;
}

+ (NSArray *)copyArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray arrayWithArray:array];
    
    for (NSUInteger i=0; i<result.count; i++) {
        id object = [result objectAtIndex:i];
        if ([object isKindOfClass:[NSObject class]] && [[object class] existDB]) {
            [result replaceObjectAtIndex:i withObject:[[TODBPointer alloc] initWithModel:object]];
        }else if ([object isKindOfClass:[NSArray class]]){
            [result replaceObjectAtIndex:i withObject:[self copyArray:object]];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [result replaceObjectAtIndex:i withObject:[self copyDictionary:object]];
        }
    }
    
    return result;
}

+ (NSDictionary *)copyDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    for (id key in result.allKeys) {
        
        id object = [result objectForKey:key];
        if ([object isKindOfClass:[NSObject class]] && [[object class] existDB]) {
            [result setObject:[[TODBPointer alloc] initWithModel:object] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [result setObject:[self copyArray:object] forKey:key];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [result setObject:[self copyDictionary:object] forKey:key];
        }
        
    }
    
    return result;
}

@end
