//
//  DRecycleCell.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
NS_ASSUME_NONNULL_BEGIN

@interface DRecycleCell : DTableViewCell

/** 封面 */
@property (strong, nonatomic) UIImageView *coverImageView;
/** 标题*/
@property (strong, nonatomic) UILabel *titleLabel;
/** 选择 */
@property (strong, nonatomic) UIImageView *selectedImageView;
/** 进度条 */
@property(nonatomic,strong)LRAnimationProgress     *pv2;



@end

NS_ASSUME_NONNULL_END
