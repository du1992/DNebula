//
//  DTodayCell.h
//  NebulaWidget
//
//  Created by DUCHENGWEN on 2019/2/27.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTodayModel.h"

/** 代码切换语言 **/
#define Localized(key)  NSLocalizedString(key, nil)

// 颜色
#define AppColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define AppAlphaColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** *  十六进制颜色 */
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBValue_alpha(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]


//背景色
#define kColorControllerBackGround UIColorFromRGBValue(0xf5f7fb)
/** * 推荐颜色 AppAlphaColor(87, 164, 254, 1) */
#define RecommendedColor AppColor(41,208, 197)
/** * 警告颜色  UIColorFromRGBValue(0xfed259) */
#define WarningColor AppColor(251,140, 52)
/** * 危险颜色 */
#define DangerousColor  AppColor(238,90, 139)
/** * 天空颜色 */
#define DSkyColor  AppColor(65, 188, 241)





NS_ASSUME_NONNULL_BEGIN

@interface DTodayCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 圆视图 */
@property (strong, nonatomic) UIView *coverView;
/** 标题*/
@property (strong, nonatomic) UILabel *titleLabel;
/** 时间*/
@property (strong, nonatomic) UILabel *timeLabel;
/** 类型*/
@property (strong, nonatomic) UILabel *typeLabel;


- (void)setWidgetData:(DTodayModel *)model;


@end

NS_ASSUME_NONNULL_END
