//
//  NSArray+CheckPointer.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/13.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "NSArray+CheckPointer.h"
#import "DBaseModel+TODBModel.h"
#import "DBaseModel+Cache.h"
#import "TODBPointer.h"
#import "TODBPointerChecker.h"
#import "TODBPointerHelper.h"

#define sql_check_point_label "to_db_model.check_point"

@interface NSObject ()

- (void)db_checkPointer:(void(^)(TODBPointerChecker *checker))block;

@end




@implementation NSArray (checkPointer)

- (void)checkPointer{
    
    
    __block NSMutableDictionary *pointerDic = [NSMutableDictionary dictionary];
    for (NSObject *obj in self) {
        [obj db_checkPointer:^(TODBPointerChecker *checker) {
            [TODBPointerHelper addChecker:checker data:pointerDic];
        }];
    }
    if (pointerDic.allKeys.count == 0) {
        return;
    }

    for (NSString *className in pointerDic.allKeys) {
        NSDictionary<NSString *,NSSet<TODBPointerChecker *> *> *dic = [TODBPointerHelper groupByID:[pointerDic objectForKey:className]];
        Class class = NSClassFromString(className);
        NSDictionary *keyValues = [class modelsByKeys:[dic allKeys]];
        for (NSString *key in dic.allKeys) {
            NSSet<TODBPointerChecker *> *checkers = [dic objectForKey:key];
            id value = [keyValues objectForKey:key];

            for (TODBPointerChecker *checker in checkers) {
                [checker.target setValue:value forKey:checker.key];
            }
        }
    }
}





@end
