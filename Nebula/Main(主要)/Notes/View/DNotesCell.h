//
//  DNotesCell.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTextView.h"
#import "DNotesModel.h"
#import "DImageView.h"
#import "HSFTimeDownView.h"
#import "HSFTimeDownConfig.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark 笔记视图

@interface DNotesCell : DTableViewCell

@property (nonatomic,strong) DNotesImageView1     *notesImageView1;
@property (nonatomic,strong) DNotesImageView2     *notesImageView2;
@property (nonatomic,strong) DNotesImageView3     *notesImageView3;
@property (nonatomic,strong) DNotesImageView4     *notesImageView4;

@property (nonatomic,strong) UILabel              *labelYear;
@property (nonatomic,strong) UILabel              *labelMonthAndDay;
@property (nonatomic,strong) UILabel              *labelMinutes;
@property (nonatomic,strong) TCTextView           *textView;
@property (nonatomic,strong) UILabel              *allLabel;

@property (nonatomic, copy) void (^singleTapGestureBlock)(NSInteger tag,UIView*view);
@end


#pragma mark 笔记头部视图
@interface DNotesHeadView : UIView

@property (nonatomic,strong) UIImageView       * bjImageView;//背景图
@property (nonatomic,strong) UIView            * bgView;//背景

@property (nonatomic,strong) UIView            * shadowView;
@property (nonatomic,strong) TCTextView        * textView;
@property (nonatomic,strong) HSFTimeDownView   * timeLabel_hsf;
@property (nonatomic,strong) UILabel           * introduce;
@end

NS_ASSUME_NONNULL_END
