//
//  UIBezierPath+ZRCovertString.h
//  ZRRefreshDemo
//
//  Created by GKY on 2017/9/4.
//  Copyright © 2017年 Run. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (ZRCovertString)

/**
 将字符串转换为具体路径

 @param string 将要转换的字符串,不能为空
 @param attributes 字符串属性,不能为空
 @return 转换的路径
 */
+ (UIBezierPath *)bezierPathWithCovertedString: (NSString *)string attrinbutes: (NSDictionary *)attributes;

/**
 @return 返回路径上所有的点,每条不相连的路径对应一个数组
 */
- (NSMutableArray<NSMutableArray<NSValue *> *> *)pointsInPath;
/**
 @return 返回路径上所有连接的子路径
 */
- (NSMutableArray<UIBezierPath *> *)zr_subpath;
@end
