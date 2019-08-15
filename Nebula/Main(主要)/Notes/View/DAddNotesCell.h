//
//  DAddNotesCell.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface DAddNotesCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView         * photoImageView;
@property (nonatomic,strong) UIButton            * cancleButton;

-(void)setData:(NSMutableArray*)photoArr cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_END
