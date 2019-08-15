//
//  UIBarButtonItem+Extension.h
//  D_notebook
//
//  Created by DUCHENGWEN on 2018/12/7.
//  Copyright © 2018年 DCW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  自定义UIBarButtonItem
 *
 *  @param taget            taget 设置点击监听者
 *  @param action           action 设置点击监听方法
 *  @param imageNormal      imageNormal 设置UIBarButtonItem图片
 *  @param imageHighlighted imageHighlighted 设置UIBarButtonItem高亮如果
 *
 */
+ (UIBarButtonItem *)barButtonItemTaget:(id)taget action:(SEL)action imageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted;

@end


