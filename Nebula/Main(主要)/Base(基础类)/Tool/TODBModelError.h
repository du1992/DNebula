//
//  TODBModelError.h
//  TODBModel
//
//  Created by Tony on 2017/12/1.
//  Copyright © 2017年 Tony. All rights reserved.
//



#ifndef TODBModelError_h
#define TODBModelError_h

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSErrorDomain const TODBModelError = @"TODBModelError";

typedef enum : NSUInteger {
    TODBModelPrivateKeyError,
    TODBModelIOError,
} TODBModelErrorType;

#endif /* TODBModelError_h */
