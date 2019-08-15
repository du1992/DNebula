//
//  DNotesVC.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "DCardModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface DNotesVC : DTableViewController

/**上级ID**/
@property(nonatomic,strong)NSString*  superiorID;
/**标题**/
@property (nonatomic,strong)NSString *cardTitle;
/**上级数据**/
@property (nonatomic,strong)DCardModel*cardModel;

@end
NS_ASSUME_NONNULL_END
