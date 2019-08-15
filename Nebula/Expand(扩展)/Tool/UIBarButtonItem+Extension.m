//
//  UIBarButtonItem+Extension.m
//  D_notebook
//
//  Created by DUCHENGWEN on 2018/12/7.
//  Copyright © 2018年 DCW. All rights reserved.
//


#import "UIBarButtonItem+Extension.h"
#import "Masonry.h"
@implementation UIBarButtonItem (Extension)

/**
 *  创建一个item
 *
 *  @param taget            点击item后调用哪个对象方法
 *  @param action           点击item后调用target的哪个方法
 *  @param imageNormal      默认的图片
 *  @param imageHighlighted 高亮的图片
 *
 *  @return 创建完的item
 */

+ (UIBarButtonItem *)barButtonItemTaget:(id)taget action:(SEL)action imageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted {
    
    /** 设置导航栏上面的内容 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateHighlighted];
    
    [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 这样创建出来之后添加到item中是不会显示出来的:  没有尺寸
        CGSize size = button.currentBackgroundImage.size;
    //    leftButton.frame = CGRectMake(0, 0, 20, 30);

    button.frame= CGRectMake(0, 0,size.width, size.height) ;
    
    // 谁push进来, 就从谁的左上角修改
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
@end

