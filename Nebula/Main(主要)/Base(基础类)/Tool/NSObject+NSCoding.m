//
//  NSObject+NSCoding.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/10.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "NSObject+NSCoding.h"
#import <objc/runtime.h>

@interface NSObject()

+ (NSDictionary *)classPropertys;

@end

@implementation NSObject (NSCoding)

+ (void)db_registNSCoding{
    Class currentClass = [self class];
    
    if (currentClass != [NSObject class]) {
        if (!class_getInstanceMethod(currentClass, @selector(initWithCoder:))){
            //创建 initWithCoder:
            [self addMethod:@selector(initWithCoder:) from:@selector(db_initWithCoder:)];
            //创建 encodeWithCoder:
            [self addMethod:@selector(encodeWithCoder:) from:@selector(db_encodeWithCoder:)];
            
            //对子属性实现 NSCoding
            NSDictionary *classPropertys = [self classPropertys];
            for (NSString *value in classPropertys.allValues) {
                NSString *regex = @"^@\"[a-zA-Z_0-9]+\"$";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                
                if ([predicate evaluateWithObject:value]) {
                    NSString *className = [value substringWithRange:NSMakeRange(2, value.length - 3)];
                    Class typeClass = NSClassFromString(className);
                    if (typeClass) {
                        [typeClass db_registNSCoding];
                    }
                }
            }
        }
    }
}

+ (void)addMethod:(SEL)selector from:(SEL)source{
    Class currentClass = [self class];
    
    Method m = class_getInstanceMethod(currentClass, source);
    const char *type = method_getTypeEncoding(m);
    IMP imp = method_getImplementation(m);
    class_addMethod(currentClass, selector, imp, type);
}

- (instancetype)db_initWithCoder:(NSCoder *)coder
{
    id result = [self init];
    if (result) {
        for (NSString *key in [[self class] classPropertys].allKeys) {
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return result;
}

- (void)db_encodeWithCoder:(NSCoder *)aCoder{
    for (NSString *key in [[self class] classPropertys].allKeys) {
        id value = [self valueForKey:key];
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }
}

@end
