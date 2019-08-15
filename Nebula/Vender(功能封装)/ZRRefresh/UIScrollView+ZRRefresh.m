//
//  UIScrollView+ZRRefresh.m
//  ZRRefreshDemo
//
//  Created by GKY on 2017/9/1.
//  Copyright © 2017年 Run. All rights reserved.
//
#import <objc/runtime.h>
#import "UIScrollView+ZRRefresh.h"

static const char ZRRefreshHeaderKey = '\0';
@implementation UIScrollView (ZRRefresh)

- (void)setZr_header:(ZRRefreshHeader *)zr_header{
    if (self.zr_header != zr_header) {
        //移除老视图，插入新视图
        [self.zr_header removeFromSuperview];
        [self insertSubview:zr_header atIndex:0];
        //kvo,runtime
        [self willChangeValueForKey:@"zr_header"];
        objc_setAssociatedObject(self, &ZRRefreshHeaderKey, zr_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"zr_header"];
    }
}

- (ZRRefreshHeader *)zr_header{
    return objc_getAssociatedObject(self, &ZRRefreshHeaderKey);
}
@end
