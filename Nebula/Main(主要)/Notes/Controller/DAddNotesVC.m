//
//  DAddNotesVC.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/20.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DAddNotesVC.h"
#import "DTextView.h"
#import "DAddNotesCell.h"
#import "DNotesModel.h"
#import "UIView+LSCore.h"
#define LeftMargin  15
#define ITEM_WIDTH ((kScreenWidth - 10 - LeftMargin * 2) / 3.0)
@interface DAddNotesVC ()<UITextViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>{
    BOOL _publishing;//是否在发布
    CGFloat _oldHeight;
    CGFloat _newHeight;
    UICollectionViewFlowLayout * _layout;
}

@property (nonatomic,strong)UIView           *segmentationView;
@property (nonatomic,strong)UICollectionView *imageCollectionView;
@property (nonatomic,strong)TCTextView       *textView;

@property (nonatomic,strong)NSMutableArray   *photoArr;
@property (nonatomic,strong)NSMutableArray   *imageUrlArr;

@end

@implementation DAddNotesVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView*segmentationView=[[UIView alloc]initWithFrame:CGRectMake(0,45, kScreenWidth, 1)];
    segmentationView.backgroundColor=UIColorFromRGBValue(0xeeeeee);
    [self.navigationController.navigationBar addSubview:segmentationView];
    self.segmentationView=segmentationView;
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.segmentationView removeFromSuperview];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newHeight = _oldHeight = 80.0;
    
    self.title=Localized(@"Notes0");
    [self addBackItem];
    [self addRightBarButtonItem:Localized(@"Home5")];
   
    [self createCollectionView];
     self.textView.placehold =Localized(@"Notes1");
}
-(void)rightItem{
    if (!self.textView.text.length) {
        [EasyTextView showErrorText:Localized(@"Notes2") config:^EasyTextConfig *{
            return [EasyTextConfig shared].setStatusType(TextStatusTypeNavigation).setBgColor(DangerousColor);
        }];
        return;
    }
    
    DNotesModel*model      =[DNotesModel crateModel];
    model.superiorID       =self.superiorID;
    model.textHeight       =_newHeight;
    model.notesTextContent =self.textView.text;
    model.createTime       =[DataManager NSDateToNSString:[NSDate date] formatter:@"yyyy-MM-dd HH:mm"];
    NSMutableArray*photoList        =[NSMutableArray array];
    BOOL isErrorText=NO;
    for (int i=0; i<self.photoArr.count; i++) {
        NSString*imgURL=[DataManager saveImage:self.photoArr[i]];
        if (imgURL) {
            [photoList addObject:imgURL];
        }else{
            isErrorText=YES;
            break;
        }
    }
    
    if (isErrorText) {
        [EasyTextView showErrorText:Localized(@"Notes3") config:^EasyTextConfig *{
            return [EasyTextConfig shared].setStatusType(TextStatusTypeNavigation).setBgColor(DangerousColor);
        }];
    }
    
    
    model.photoList        =photoList;
    if (_oldHeight == _newHeight) {
        CGSize size =[self.view getStringRectInTextView:self.textView.text InTextView:self.textView];
        model.textHeight       =size.height;
    }
    [model getCellHeight];
    [model save:nil];
    
    WEAKSELF
    EasyLoadingView *LoadingV =[EasyLoadingView showLoadingText:@"" imageName:@"保存中" config:^EasyLoadingConfig *{
        static int a = 0 ;
        int type = ++a%2 ? LoadingShowTypeImageUpturnLeft : LoadingShowTypeImageUpturn ;
        return [EasyLoadingConfig shared].setLoadingType(type).setBgColor([UIColor blackColor]).setTintColor([UIColor whiteColor]).setSuperReceiveEvent(NO);
    }];
    dispatch_queue_after_S(0.5, ^{
         [weakSelf backButtonClicked];
        [EasyLoadingView hidenLoading:LoadingV];
        if (weakSelf.updateTata) {
            weakSelf.updateTata(nil, nil);
        }
       
    });

    
   
    
}
- (void)createCollectionView {
   
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
    _layout.sectionInset = UIEdgeInsetsMake(10, LeftMargin, 5, LeftMargin);
    _layout.headerReferenceSize = CGSizeMake(kScreenWidth, _newHeight + 10);
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,0) collectionViewLayout:_layout];
    self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.imageCollectionView registerClass:[DAddNotesCell class] forCellWithReuseIdentifier:@"DAddNotesCell"];
    [self.imageCollectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TextHeaderView"];
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.view addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photoArr.count<6) {
       return self.photoArr.count+1;
    }
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DAddNotesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAddNotesCell" forIndexPath:indexPath];
    [cell setData:self.photoArr cellForItemAtIndexPath:indexPath];
    [cell.cancleButton addTarget:self action:@selector(canclePhotoSelect:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)canclePhotoSelect:(UIButton *)sender {
    [self.photoArr removeObjectAtIndex:sender.tag];
    [self.imageCollectionView reloadData];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView * reuserView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TextHeaderView" forIndexPath:indexPath];
        [reuserView addSubview:self.textView];
        return reuserView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    if (self.photoArr.count<6&&self.photoArr.count==indexPath.row) {
        //点击加号
        [self photoBtnClicked];
    }else{
        
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //垂直方向
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // 水平方向
    return 5;
}
- (void)textViewDidChange:(UITextView *)textView{
   CGSize size =[self.view getStringRectInTextView:textView.text InTextView:textView];
    _newHeight = size.height;
    if (_newHeight < 80) {
        _newHeight = 80;
    }
    if (_oldHeight == _newHeight) {
        return;
    }
    _oldHeight = _newHeight;
    _layout.headerReferenceSize = CGSizeMake(kScreenWidth, _newHeight + 10);
    self.textView.height = size.height;
}
- (TCTextView *)textView {
    if (!_textView) {
        _textView = [[TCTextView alloc]initWithFrame:CGRectMake(LeftMargin, 0, kScreenWidth - LeftMargin * 2, 80)];
        [_textView setDelegate:self];
        _textView.placehold = @"说点什么~";
        _textView.textColor = UIColorFromRGBValue(0x333333);
        _textView.placeholdLabel.textColor = UIColorFromRGBValue(0xE2E2E2);
        _textView.scrollEnabled = NO;
        _textView.font = AppFont(14);
    }
    return _textView;
}
- (NSMutableArray *)photoArr {
    if (!_photoArr) {
        _photoArr = [[NSMutableArray alloc]init];
    }
    return _photoArr;
}
- (NSMutableArray *)imageUrlArr {
    if (!_imageUrlArr) {
        _imageUrlArr = [[NSMutableArray alloc]init];
    }
    return _imageUrlArr;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}


- (void)photoBtnClicked {
   if (self.photoArr.count == 6) {
        //图片满了
        NSLog(@"图片满了");
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(6 - self.photoArr.count) columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;//原图
    imagePickerVc.allowCrop = NO;
    
    WEAKSELF
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        [weakSelf.photoArr removeAllObjects];
        [weakSelf.photoArr addObjectsFromArray:photos];
        [weakSelf handelPhotoArr];
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        [weakSelf handelPhotoArr];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
- (void)handelPhotoArr {
//    if (self.photoArr.count < 6) {
//        [self addDefaultPhoto];
//    }
    [self.imageCollectionView reloadData];
}
@end
