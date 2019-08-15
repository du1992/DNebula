//
//  DRecycleModel.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHomeModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface DRecycleModel : DBaseModel


/**标题**/
@property (nonatomic,strong) NSString *homeTitle;
/**描述**/
@property (nonatomic,strong) NSString *homeDescribe;
/**封面**/
@property (nonatomic,strong) NSString *homeCover;
/**状态类型**/
@property(nonatomic)kStateType         stateType;
/**完成度**/
@property(nonatomic)NSInteger         completeProportion;
/**图标**/
@property(nonatomic,strong) NSString    *ico;

/**向下的ID**/
@property (nonatomic,strong) NSString* downID;

+ (NSMutableArray<DHomeModel *> *)createData;

-(void)reset;



-(void)saveModel:(DHomeModel*)model;

@end
NS_ASSUME_NONNULL_END
