//
//  DTableViewCell.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTableViewCell.h"

@implementation DTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *cellIdentifier = NSStringFromClass([self class]);
    DTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setData:(DBaseModel *)model{
   
    
    
}

@end
