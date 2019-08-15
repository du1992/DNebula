//
//  YCPhotoBrowserAnimator.h
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/2/25.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimatorPresentedDelegate <NSObject>
@required
- (UIImageView *)imageViewWithIndexPath:(NSIndexPath *)index;
@end

@protocol AnimatorDismissedDelegate <NSObject>
@required
- (NSIndexPath *)indexPathForDimissView;
- (UIImageView *)imageViewForDimissView;
@end


@interface YCPhotoBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

// 外界需要赋值
@property(nonatomic,weak)id<AnimatorPresentedDelegate>   presentedDelegate;

@property(nonatomic,weak)id<AnimatorDismissedDelegate>   dismissedDelegate;
@property(nonatomic,strong)NSIndexPath                   *indexPath;

- (instancetype)initWithPresentedDelegate:(id<AnimatorPresentedDelegate>)delegate;
@end
