//
//  DNotesDetailsVC.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNotesModel.h"
#import "DCardModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface DNotesDetailsVC : DTableViewController
/**集合数据**/
@property (nonatomic,strong)DCardModel*cardModel;

@property(nonatomic,strong)DNotesModel *model;

@end
NS_ASSUME_NONNULL_END
