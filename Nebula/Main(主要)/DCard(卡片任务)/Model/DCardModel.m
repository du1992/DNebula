//
//  DCardModel.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DCardModel.h"

@implementation DCardModel
+ (void)load{
    [self regiestDB];
}

//主键ID
+ (NSString *)db_pk{
    return @"primaryID";
}

//获取封面图片
-(UIImage*)getCoverImage{
    UIImage*image;
    if (self.cardCover.length>8) {
        image=[DataManager getImage:self.cardCover];
    }else{
        if ([self.cardCover isEqualToString:@"首页封面提示"]) {
            image=ImageNamed(@"首页封面提示");
        }else{
            
            NSString*st=[NSString stringWithFormat:@"bg_%@",self.cardCover];
            image=ImageNamed(st);
        }
    }
   
    return image;
}

@end
