//
//  DChoseView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCardView.h"
#import "DCardModel.h"
#import "DHomeModel.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
NS_ASSUME_NONNULL_BEGIN
@interface DChoseView : UIView
@property (nonatomic, copy) void (^imgBegan) (void);
@property (nonatomic, copy) void (^completeUpdateTata) (NSString*text);

/** 背景视图 */
@property(nonatomic,strong)UIView      *alphaiView;
/** 内容视图 */
@property(nonatomic,strong)UIView      *bottomView;
/** 卡片视图 */
@property(nonatomic,strong)DCardView   *cardView;
/** 封面 */
@property(nonatomic,strong)UIImageView *coverImg;
/** 封面提示 */
@property(nonatomic,strong)UILabel     *coverLabel;
/** 关闭按钮 */
@property(nonatomic,strong)UIButton   *closeButton;
/** 确定按钮 */
@property(nonatomic,strong)UIButton   *sureButton;
/** 分割线 */
@property(nonatomic,strong)UIView     *lineView;
/** 标题 */
@property(nonatomic,strong)JhtHorizontalMarquee     *titleLabel;
/** 进度条 */
@property(nonatomic,strong)LRAnimationProgress     *pv2;
/**
 *  点击按钮弹出
 */
-(void)show;
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss;


@property (strong,nonatomic) UITextField      *titleTextView;

@property (nonatomic, strong) UIButton        *completeButton;

@property(nonatomic,strong)   DBaseModel     *model;

@property (nonatomic, strong) NSMutableArray   *cardArray;

-(void)refreshData;



@end
NS_ASSUME_NONNULL_END
