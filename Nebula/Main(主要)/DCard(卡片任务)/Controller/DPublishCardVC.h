//
//  DPublishClassificationVC.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCardModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PublishCardUpdateTata)(DCardModel*model,BOOL isAdd);

@interface DPublishCardVC : DViewController
/**上级数据**/
@property(nonatomic,strong)DCardModel*model;
/**上级ID**/
@property(nonatomic,strong)NSString*  superiorID;

@property (nonatomic,strong) PublishCardUpdateTata  cardUpdateTata;

@end
NS_ASSUME_NONNULL_END
