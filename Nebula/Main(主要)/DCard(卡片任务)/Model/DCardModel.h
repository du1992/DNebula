//
//  DCardModel.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DCardModel : DBaseModel

/**上级ID**/
@property (nonatomic,strong) NSString* superiorID;
/**标题**/
@property (nonatomic,strong) NSString *cardTitle;
/**封面**/
@property (nonatomic,strong) NSString *cardCover;
/**设置的时间**/
@property(nonatomic,strong) NSString *chooseTime;
/**计时类型**/
@property (nonatomic,assign)NSUInteger timeType;
/**音乐标题**/
@property (nonatomic,strong) NSString *musicTitle;

/**音乐下标**/
@property (nonatomic,strong)NSString* curIndex;

//获取封面图片
-(UIImage*)getCoverImage;
@end
NS_ASSUME_NONNULL_END
