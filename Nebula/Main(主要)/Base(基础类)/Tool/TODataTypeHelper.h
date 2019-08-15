//
//  TODataTypeHelper.h
//  TODBModel
//
//  Created by Tony on 16/11/28.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef objcType2SqlType

#define objcType2SqlType(type) [TODataTypeHelper objcTypeToSqlType:type]

#endif

#define DB_TYPE_INTEGER     @"INTEGER"
#define DB_TYPE_REAL        @"REAL"
#define DB_TYPE_TEXT        @"TEXT"
#define DB_TYPE_BLOB        @"BLOB"

#define DB_NULL             @"null"



@interface TODataTypeHelper : NSObject

/**
 Charge a objc-type to sqlite-type

 @param objcType objc-type
 @return sqlite-type
 */
+ (NSString *)objcTypeToSqlType:(const char *)objcType;


/**
 Charge a objc-object to sqlite-object


 @param objcObject objc-object
 @param type sqlite-type
 @param arguments arguments with bitcode
 @return sqlite-object
 */
+ (NSString *)objcObjectToSqlObject:(id)objcObject  withType:(NSString *)type arguments:(NSMutableArray *)arguments;


/**
 Read a objc-object from FMResultSet

 @param resultSet source FMResultSet
 @param name reading name
 @param objcType objc-type
 @return objc-object
 */
+ (id)readObjcObjectFrom:(FMResultSet *)resultSet name:(NSString *)name type:(NSString *)objcType;


/**
 Copy a NSArray. Replace TODBPointer with TODBModel

 @param array source array
 @return result array
 */
+ (NSArray *)copyArray:(NSArray *)array;

/**
 Copy a NSDictionary. Replace TODBPointer with TODBModel
 
 @param array source dictionary
 @return result dictionary
 */
+ (NSDictionary *)copyDictionary:(NSDictionary *)array;

@end
