//
//  DAddNotesCell.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DAddNotesCell.h"

@implementation DAddNotesCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        
    }
    return self;
}
- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self);
        make.top.left.mas_equalTo(self);
    }];
    
    [self.contentView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.photoImageView.mas_right).offset(-self.height/15);
        make.top.equalTo(self.photoImageView).offset(self.height/12);
        make.width.equalTo(@17);
        make.height.equalTo(@16);
    }];
    self.cancleButton.hidden=YES;
}
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.backgroundColor = UIColorFromRGBValue(0xf5f7fb);
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
    }
    return _photoImageView;
}
- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setImage:ImageNamed(@"删除图片") forState:UIControlStateNormal];
    }
    
    return _cancleButton;
}

-(void)setData:(NSMutableArray*)photoArr cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (photoArr.count==indexPath.row) {
        self.photoImageView.image =ImageNamed(@"添加照片");
        self.cancleButton.hidden=YES;
    }else{
        self.cancleButton.hidden=NO;
        self.cancleButton.tag = indexPath.row;
        self.photoImageView.image =photoArr[indexPath.row];
    }
}


@end
