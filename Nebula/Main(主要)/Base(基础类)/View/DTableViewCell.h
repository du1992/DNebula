//
//  DTableViewCell.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setData:(DBaseModel *)model;




@end

NS_ASSUME_NONNULL_END
