//
//  DImageView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/3/1.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DImageView.h"

#pragma mark 横向图片视图
@implementation DTransverseImageView
- (void)setLayout {
    
    //图片视图；左边
    [self.leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.width.mas_equalTo(TransverseImageWIDTH);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    
    //图片视图；中间
    [self.centerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(TransverseImageWIDTH);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    
    //图片视图；右边
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(TransverseImageWIDTH);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    
}


-(UIImageView *)leftIV{
    if (!_leftIV) {
        _leftIV = [[UIImageView alloc]init];
        [self addSubview:_leftIV];
        _leftIV.contentMode = UIViewContentModeScaleAspectFill;
        _leftIV.userInteractionEnabled = YES;
        _leftIV.layer.cornerRadius=3;
        _leftIV.clipsToBounds = YES;
        _leftIV.tag=0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_leftIV addGestureRecognizer:tap];
    }
    return _leftIV;
}
-(UIImageView *)centerIV{
    if (!_centerIV) {
        _centerIV = [[UIImageView alloc]init];
        [self addSubview:_centerIV];
        _centerIV.contentMode = UIViewContentModeScaleAspectFill;
        _centerIV.userInteractionEnabled = YES;
        _centerIV.layer.cornerRadius=3;
        _centerIV.clipsToBounds = YES;
        _centerIV.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_centerIV addGestureRecognizer:tap];
    }
    return _centerIV;
}
-(UIImageView *)rightIV{
    if (!_rightIV) {
        _rightIV = [[UIImageView alloc]init];
        [self addSubview:_rightIV];
        _rightIV.contentMode = UIViewContentModeScaleAspectFill;
        _rightIV.userInteractionEnabled = YES;
        _rightIV.layer.cornerRadius=3;
        _rightIV.clipsToBounds = YES;
        _rightIV.tag=2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_rightIV addGestureRecognizer:tap];
    }
    return _rightIV;
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(tap.view.tag,tap.view);
    }
}
//重置
-(void)resetView{
    self.leftIV.hidden     =YES;
    self.centerIV.hidden   =YES;
    self.rightIV.hidden    =YES;
}
//赋值
- (void)setData:(id)parameter skipList:(int)skipList{
    NSArray*photoList=parameter;
    [self resetView];
    if (photoList.count>0+skipList) {
        self.leftIV.hidden=NO;
        NSString* object=photoList[0+skipList];
        self.leftIV.image=[DataManager getImage:object];
    }
    
    if (photoList.count>1+skipList) {
        self.centerIV.hidden=NO;
        NSString* object   =photoList[1+skipList];
        self.centerIV.image=[DataManager getImage:object];
    }
    if (photoList.count>2+skipList) {
        self.rightIV.hidden=NO;
        NSString* object   =photoList[2+skipList];
        self.rightIV.image=[DataManager getImage:object];
    }
}
@end




#pragma mark 图片视图1
@implementation DNotesImageView1
- (void)setLayout {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.cornerRadius=3;
        _imageView.clipsToBounds = YES;
        _imageView.tag=0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(tap.view.tag,tap.view);
    }
}

//赋值
- (void)setData:(id)parameter{
    NSArray*photoList=parameter;
    NSString* object=photoList[0];
    self.imageView.image=[DataManager getImage:object];
    
}
@end



#pragma mark 图片视图2
@implementation DNotesImageView2
- (void)setLayout {
    
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(NotesImageWIDTH, NotesImageWIDTH));
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(NotesImageWIDTH, NotesImageWIDTH));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

-(UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc]init];
        [self addSubview:_imageView1];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.userInteractionEnabled = YES;
        _imageView1.layer.cornerRadius=3;
        _imageView1.clipsToBounds = YES;
        _imageView1.tag=0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView1 addGestureRecognizer:tap];
    }
    return _imageView1;
}
-(UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc]init];
        [self addSubview:_imageView2];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.userInteractionEnabled = YES;
        _imageView2.layer.cornerRadius=3;
        _imageView2.clipsToBounds = YES;
        _imageView2.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView2 addGestureRecognizer:tap];
    }
    return _imageView2;
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(tap.view.tag,tap.view);
    }
}

//赋值
- (void)setData:(id)parameter{
    NSArray*photoList=parameter;
    NSString* object1=photoList[0];
    self.imageView1.image=[DataManager getImage:object1];
    NSString* object2=photoList[1];
    self.imageView2.image=[DataManager getImage:object2];
    
}
@end



#pragma mark 图片视图3
@implementation DNotesImageView3
- (void)setLayout {
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.mas_top).offset(0);
         make.size.mas_equalTo(CGSizeMake(130, 130));
         make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView2.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(130, 130));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView2.mas_top).offset(0);
        make.bottom.mas_equalTo(self.imageView3.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.imageView2.mas_left).offset(-1);
    }];
    
    
}
-(UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc]init];
        [self addSubview:_imageView1];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.userInteractionEnabled = YES;
        _imageView1.layer.cornerRadius=3;
        _imageView1.clipsToBounds = YES;
        _imageView1.tag=0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView1 addGestureRecognizer:tap];
    }
    return _imageView1;
}
-(UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc]init];
        [self addSubview:_imageView2];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.userInteractionEnabled = YES;
        _imageView2.layer.cornerRadius=3;
        _imageView2.clipsToBounds = YES;
        _imageView2.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView2 addGestureRecognizer:tap];
    }
    return _imageView2;
}
-(UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc]init];
        [self addSubview:_imageView3];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.userInteractionEnabled = YES;
        _imageView3.layer.cornerRadius=3;
        _imageView3.clipsToBounds = YES;
        _imageView3.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView3 addGestureRecognizer:tap];
    }
    return _imageView3;
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(tap.view.tag,tap.view);
    }
}

//赋值
- (void)setData:(id)parameter{
    NSArray*photoList=parameter;
    NSString* object1=photoList[0];
    self.imageView1.image=[DataManager getImage:object1];
    NSString* object2=photoList[1];
    self.imageView2.image=[DataManager getImage:object2];
    NSString* object3=photoList[2];
    self.imageView3.image=[DataManager getImage:object3];
    
}
@end


#pragma mark 图片视图4
@implementation DNotesImageView4
- (void)setLayout {
    
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(220);
    }];
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView1.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(NotesImageWIDTH4, NotesImageWIDTH4));
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView1.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(NotesImageWIDTH4, NotesImageWIDTH4));
        make.left.mas_equalTo(self.imageView2.mas_right).offset(1);
    }];
    
    [self.imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView1.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(NotesImageWIDTH4, NotesImageWIDTH4));
        make.left.mas_equalTo(self.imageView3.mas_right).offset(1);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.imageView4).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
  
   
   
    
    
}
-(UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc]init];
        [self addSubview:_imageView1];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.userInteractionEnabled = YES;
        _imageView1.layer.cornerRadius=3;
        _imageView1.clipsToBounds = YES;
        _imageView1.tag=0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView1 addGestureRecognizer:tap];
    }
    return _imageView1;
}
-(UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc]init];
        [self addSubview:_imageView2];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.userInteractionEnabled = YES;
        _imageView2.layer.cornerRadius=3;
        _imageView2.clipsToBounds = YES;
        _imageView2.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView2 addGestureRecognizer:tap];
    }
    return _imageView2;
}
-(UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc]init];
        [self addSubview:_imageView3];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.userInteractionEnabled = YES;
        _imageView3.layer.cornerRadius=3;
        _imageView3.clipsToBounds = YES;
        _imageView3.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView3 addGestureRecognizer:tap];
    }
    return _imageView3;
}
-(UIImageView *)imageView4{
    if (!_imageView4) {
        _imageView4 = [[UIImageView alloc]init];
        [self addSubview:_imageView4];
        _imageView4.contentMode = UIViewContentModeScaleAspectFill;
        _imageView4.userInteractionEnabled = YES;
        _imageView4.layer.cornerRadius=3;
        _imageView4.clipsToBounds = YES;
        _imageView4.tag=1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_imageView4 addGestureRecognizer:tap];
    }
    return _imageView4;
}
-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        [self addSubview:_promptLabel];
        _promptLabel.layer.cornerRadius=3;
        _promptLabel.clipsToBounds = YES;
        _promptLabel.textColor=[UIColor whiteColor];
        _promptLabel.font=AppBoldFont(20);
        _promptLabel.backgroundColor=AppAlphaColor(0,0,0, 0.2);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text=@"+1";
    
    }
    return _promptLabel;
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(tap.view.tag,tap.view);
    }
}

//赋值
- (void)setData:(id)parameter{
    self.promptLabel.hidden=YES;
    NSArray*photoList=parameter;
    NSString* object1=photoList[0];
    self.imageView1.image=[DataManager getImage:object1];
    NSString* object2=photoList[1];
    self.imageView2.image=[DataManager getImage:object2];
    NSString* object3=photoList[2];
    self.imageView3.image=[DataManager getImage:object3];
    NSString* object4=photoList[3];
    self.imageView4.image=[DataManager getImage:object4];
    if (photoList.count>4) {
         self.promptLabel.hidden=NO;
        self.promptLabel.text=[NSString stringWithFormat:@"+%lu",(unsigned long)photoList.count];
    }
    
}
@end
