//
//  DIndicatorView.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#pragma mark -  网络指示器
@interface DIndicatorView : UIView

//开始动画
-(void)startAllAnimation;
//删除动画
-(void)removeAllAnimation;
// 恢复
- (void)resumeLayer;



@end
NS_ASSUME_NONNULL_END
