//
//  DTableView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define DTableViewDefaultBottmRefreshingMargin 200
typedef void (^DTableViewRefreshCallBack)(void);

@interface DTableView : UITableView

//如果row总数为0时显示
@property (nonatomic) UIView *emptyView;

//emptyView上方空隙
@property (nonatomic) CGFloat emptyViewTopPadding;

#pragma mark - header & footer refreshing

/** 触发bottom刷新的距离，默认为TCTableViewDefaultBottmRefreshingMargin:800 */
@property (nonatomic) CGFloat footerRefresingBeginBottmMarign;




- (void) headerEndRefreshing;

- (void) footerEndRefreshing;





- (void) addFooterWithCallback:(DTableViewRefreshCallBack)callBack;

- (void) addFooterWithTarget:(id)target action:(SEL)action;

- (void) removeHeader;

- (void) removeFooter;

- (void) startLoading;

- (void) stopLoading;

- (void) stopRefreshingAndLoading;

@property (nonatomic) BOOL loading;





@end
NS_ASSUME_NONNULL_END
