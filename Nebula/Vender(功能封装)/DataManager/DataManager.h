//
//  DataManager.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/18.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define kHomeAnimation             @"KHomeAnimation" //开屏动画是否演示过
#define KAPPComments               @"KAPPComments" //评论
#define KCommentsNumber            @"KCommentsNumber" //评论计数
#define kTransparency              @"kTransparency" //透明度

#define kInstructions              @"kInstructions" //帮助说明

@interface DataManager : NSObject

//获取数据
+(id)getDataKey:(NSString*)key;
//设置提示
+(void)setDataKey:(NSString *)key;
//设置数据
+(void)setDataKey:(NSString *)key data:(id)data;

//储存图片到沙盒
+(NSString*)saveImage:(UIImage *)image;
//取出保存的图片
+(UIImage*)getImage:(NSString *)filePathString;

/** NSString转换NSDate */
+ (NSDate *)NSStringDateToNSDate:(NSString *)datetime formatter:(NSString *)format;

/** NSDate转换NSString */
+ (NSString *)NSDateToNSString:(NSDate *)datetime formatter:(NSString *)format;
@end
NS_ASSUME_NONNULL_END
