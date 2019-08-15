//
//  DCollectionView.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/13.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DCollectionViewController.h"

@interface DCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation DCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    [self initializeCollectionView];
}
-(void)initializeData{
    
}
- (void)initializeCollectionView{
    
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 3, kScreenWidth, kScreenHeight- 64 ) collectionViewLayout:layout];
     self.collectionView.backgroundColor = [UIColor whiteColor];
     self.collectionView.dataSource = self;
     self.collectionView.delegate = self;
     [self.view addSubview:self.collectionView];
    
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.listArray.count;
}




#pragma mark - UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}





@end
