//
//  DChooseMusicView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface DChooseMusicCell : UITableViewCell
/** 封面 */
@property (strong, nonatomic) UIImageView *coverImageView;
/** 标题*/
@property (strong, nonatomic) UILabel *titleLabel;
/** 选择 */
@property (strong, nonatomic) UIImageView *selectedImageView;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end




@interface DChooseMusicView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void (^chooseMusicUpdateTata) (NSInteger curIndex);

/** 内容视图 */
@property(nonatomic,strong)UIView      *bottomView;
/** 视图 */
@property(nonatomic,strong)UITableView *tableView;
/** 数据*/
@property (nonatomic, strong) NSMutableArray      *listArray;
/** 进度条 */
@property(nonatomic,strong)LRAnimationProgress     *pv2;

@property (assign, nonatomic)NSInteger curIndex;
/**
 *  点击按钮弹出
 */
-(void)show;
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss;




@end

NS_ASSUME_NONNULL_END
