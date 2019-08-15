//
//  DPhotoTableViewCell.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DPhotoTableViewCell.h"
@implementation DPhotoModel     @end


@implementation DPhotoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setLayout];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (void)setLayout{
    [self.notesImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(0);
    }];
    
}
- (UIImageView *)notesImage {
    if (!_notesImage) {
        _notesImage = [[UIImageView alloc]init];
        _notesImage.contentMode= UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_notesImage];
    }
    return _notesImage;
}


-(void)setData:(DPhotoModel *)model{
    self.notesImage.image=model.photoImg;
    
    
    
    
}




@end
