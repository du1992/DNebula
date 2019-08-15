//
//  DCollectionView.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/13.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface DCollectionViewController : DViewController

@property (nonatomic, strong) NSMutableArray   *listArray;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

NS_ASSUME_NONNULL_END
