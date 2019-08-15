//
//  UIImageView+GIFExtension.h
//  DWPromptAnimationTest
//
//  Created by dwang_sui on 16/8/29.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>




@interface UIImageView (GIFExtension)

/**
 *  为UIImageView添加一个设置gif图内容的方法
 *
 *  @imageUrl GIF图URL
 */
-(void)dw_SetImage:(NSURL *)imageUrl ;

@end
