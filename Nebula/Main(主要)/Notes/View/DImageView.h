//
//  DImageView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/3/1.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNotesModel.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark 横向图片视图
@interface DTransverseImageView : DView
@property (nonatomic,strong) UIImageView *leftIV;
@property (nonatomic,strong) UIImageView *centerIV;
@property (nonatomic,strong) UIImageView *rightIV;
/** 重置 */
-(void)resetView;
/** 赋值 */
- (void)setData:(id)parameter skipList:(int)skipList;

@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);

@end


#pragma mark 图片视图1
@interface DNotesImageView1 : DView
@property (nonatomic,strong) UIImageView *imageView;
/** 赋值 */
- (void)setData:(id)parameter;
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);
@end



#pragma mark 图片视图2
@interface DNotesImageView2 : DView
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
/** 赋值 */
- (void)setData:(id)parameter;
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);
@end


#pragma mark 图片视图3
@interface DNotesImageView3 : DView
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;
/** 赋值 */
- (void)setData:(id)parameter;
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);
@end


#pragma mark 图片视图4
@interface DNotesImageView4 : DView
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;
@property (nonatomic,strong) UIImageView *imageView4;
@property (nonatomic,strong) UILabel     *promptLabel;
/** 赋值 */
- (void)setData:(id)parameter;
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);
@end






NS_ASSUME_NONNULL_END
