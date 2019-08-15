//
//  DSphereView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/22.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DSphereView : UIView
/**创建**/
- (void)setCloudTags:(NSArray *)array;
/**开始**/
- (void)timerStart;
/**停止**/
- (void)timerStop;



@end

NS_ASSUME_NONNULL_END
