//
//  TODBPointer.h
//  TODBModel
//
//  Created by Tony on 16/11/30.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TODBPointer : NSObject<NSCoding>

@property (nonatomic,copy) NSString *pkValue;
@property (nonatomic,copy) NSString *className;
@property (nonatomic,readonly) NSObject *model;

- (instancetype)initWithModel:(NSObject *)model;

@end
