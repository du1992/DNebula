//
//  DRecycleCell.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DRecycleCell.h"
#import "DRecycleModel.h"
@implementation DRecycleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setLayout];
        
    }
    return self;
}




- (void)setLayout {
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(5);
    }];
    self.selectedImageView.image=ImageNamed(@"选择");
    self.selectedImageView.hidden=YES;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(5);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.selectedImageView.left).offset(5);
    }];
    self.titleLabel.text=@"这是一个标题";
   
    LRAnimationProgress *pv2 = [[LRAnimationProgress alloc] initWithFrame:CGRectMake(95,50, kScreenWidth-100, 16)];
    [self addSubview:pv2];
    pv2.backgroundColor = [UIColor clearColor];
    pv2.layer.cornerRadius = 16/2;
    pv2.progressTintColors = @[LRColorWithRGB(0xC6FFDD),LRColorWithRGB(0xFBD786),LRColorWithRGB(0xf7797d)];
    pv2.hideStripes = YES;
    pv2.numberOfNodes = 10;
    pv2.hideAnnulus = NO;
    self.pv2=pv2;
    
    
    UIView*lineViewA=[[UIView alloc]init];
    lineViewA.backgroundColor=[UIColor colorWithRed:2/255.0 green:2/255.0 blue:2/255.0 alpha:0.1];;
    [self addSubview:lineViewA];
    [lineViewA mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    
}






-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.layer.cornerRadius=4;
        _coverImageView.clipsToBounds = YES;
        [self addSubview:_coverImageView];
    }
    return _coverImageView;
}
-(UIImageView *)selectedImageView{
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc]init];
        [self addSubview:_selectedImageView];
    }
    return _selectedImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
        [_titleLabel setFont:AppBoldFont(20)];
        _titleLabel.textColor=UIColorFromRGBValue(0x363636);
    }
    return _titleLabel;
}


-(void)setData:(DRecycleModel *)model{
    self.titleLabel.text=model.homeTitle;
    UIImage *filePath=[DataManager getImage:model.ico];
    if (filePath) {
        self.coverImageView.image = filePath;
    }else{
        self.coverImageView.image = [UIImage imageNamed:@"球图标"];
    }
    float completeProportion = ((float)model.completeProportion/10);
    [self.pv2 setProgress:completeProportion animated:YES];
}

@end
