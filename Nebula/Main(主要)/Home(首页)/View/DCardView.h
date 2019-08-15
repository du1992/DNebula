//
//  DCardView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCardModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^CardUpdateTata)(DCardModel*model,NSInteger curIndex);

@interface DCardView : UICollectionView

@property (nonatomic, retain) NSArray *imgDatas;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,strong) CardUpdateTata   updateTata;

@end

NS_ASSUME_NONNULL_END
