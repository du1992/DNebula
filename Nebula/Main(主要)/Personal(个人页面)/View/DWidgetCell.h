//
//  DWidgetCell.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/3/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface DTodayModel : NSObject
@property (nonatomic,strong)NSString *chooseTime;
@property (nonatomic,strong)NSString *cardTitle;
@property (nonatomic,strong)NSString *timeType;
@property (nonatomic,strong)NSString *openNewsID;
@end



@interface DWidgetCell : DTableViewCell

/** 圆视图 */
@property (strong, nonatomic) UIView *coverView;
/** 标题*/
@property (strong, nonatomic) UILabel *titleLabel;
/** 时间*/
@property (strong, nonatomic) UILabel *timeLabel;
/** 类型*/
@property (strong, nonatomic) UILabel *typeLabel;


- (void)setWidgetData:(NSDictionary *)dictionary;



@end

NS_ASSUME_NONNULL_END
