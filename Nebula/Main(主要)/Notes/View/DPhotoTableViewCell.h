//
//  DPhotoTableViewCell.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DPhotoModel : DBaseModel

@property(nonatomic,strong)UIImage*  photoImg;
@property(nonatomic       )CGFloat   photoHeight;

@end





@interface DPhotoTableViewCell : DTableViewCell

@property (nonatomic,strong) UIImageView * notesImage;

@end
NS_ASSUME_NONNULL_END
