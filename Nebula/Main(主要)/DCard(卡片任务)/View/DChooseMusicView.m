//
//  DChooseMusicView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DChooseMusicView.h"

@implementation DChooseMusicCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *cellIdentifier = @"DChooseMusicCell";
    DChooseMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setLayout];
       
    }
    return self;
}




- (void)setLayout {
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    self.coverImageView.image=ImageNamed(@"音乐图标");
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    self.selectedImageView.image=ImageNamed(@"选择");
    self.selectedImageView.hidden=YES;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.selectedImageView.left).offset(5);
    }];
    
    
    
    
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

@end




@implementation DChooseMusicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=AppAlphaColor(0, 0, 0, 0.3);
        [self setLayout];
        self.hidden=YES;
        //        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        //        [self addGestureRecognizer:tapGes];
    }
    return self;
}
-(void)setLayout{
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight,kScreenWidth,200)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.bottomView.userInteractionEnabled=YES;
    self.bottomView.layer.cornerRadius=5;
    self.bottomView.clipsToBounds = YES;
    
    self.tableView=[[UITableView alloc]init];
    [self.bottomView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(0);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.userInteractionEnabled=YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIButton*button=[[UIButton alloc]init];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    
    
    
    
}

/**
 *  点击按钮弹出
 */
-(void)show{
    self.hidden=NO;
    [self.tableView reloadData];
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight-250,kScreenWidth,250);
        
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss{
    [UIView animateWithDuration: 0.35 animations: ^{
        self.bottomView.frame=CGRectMake(0,kScreenHeight,kScreenWidth,250);
        
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
    
}

-(void)timeTypeAction:(UIButton*)button{
    [self dismiss];
    //    if (self.updateTata) {
    //        self.updateTata(button.tag);
    //    }
    
}

#pragma mark  - UITableViewDelegate-回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArray.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DChooseMusicCell *cell =    [DChooseMusicCell cellWithTableView:tableView];
    DMusicModel *model     =    self.listArray[indexPath.row];
    NSString*imgString=[NSString stringWithFormat:@"music%ld",(long)indexPath.row];
    cell.titleLabel.text        =    model.musicTitle;
    cell.coverImageView.image   =    ImageNamed(imgString);
    
    if (self.curIndex==indexPath.row) {
        cell.selectedImageView.hidden=NO;
    }else{
        cell.selectedImageView.hidden=YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DMusicModel *model = self.listArray[indexPath.row];
    [[DMusicPlayer sharedInstance]playMusic:[NSString stringWithFormat:@"music%ld",(long)indexPath.row]];
     self.curIndex=indexPath.row;
    [self.tableView reloadData];
    if (self.chooseMusicUpdateTata) {
        self.chooseMusicUpdateTata(indexPath.row);
    }
}
@end
