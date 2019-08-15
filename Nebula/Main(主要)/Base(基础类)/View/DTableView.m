//
//  DTableView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTableView.h"

@interface DTableView(){
    
   
    UIRefreshControl *_refreshControl;
    UIView *_footerView;
    UIEdgeInsets _userContentEdgeInsets;
    CGFloat _startDragY;
    
    NSMutableArray *_headerCallBacks;
    NSMutableArray *_footerCallBacks;
    
    BOOL _startLoading;
    
    NSTimeInterval _lastFooterRefreshTime;//记录上次底部刷新时间，间隔至少0.5秒
}

@end


@implementation DTableView

- (void) setup{
    [self setSeparatorInset:UIEdgeInsetsZero];
    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    self.separatorColor = [UIColor colorWithWhite:(236)/255.0 alpha:1];
    //XXX 如不设置在tableView为空的情况会出现多余的线
    self.tableFooterView = [UIView new];
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    
}


- (id) initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if( self = [super initWithFrame:frame style:style] ){
        [self setup];
    }
    return self;
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //    TCLOG(@"hitTest %@",event);
    if( _footerCallBacks.count ){
        _startDragY = self.contentOffset.y;
    }
    UIView *v = [super hitTest:point withEvent:event];
    if( self.tag == 54321 ){
       
    }
    return v;
}


- (void) setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
    [super setContentOffset:contentOffset animated:animated];
    [self contentOffsetChanged:contentOffset];
}

- (void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    [self contentOffsetChanged:contentOffset];
}

- (void) setEmptyView:(UIView *)emptyView{
    [_emptyView removeFromSuperview];
    
    _emptyView = emptyView;
    
    emptyView.hidden = YES;
    [self addSubview:emptyView];
    [self setNeedsLayout];
}


- (void) layoutSubviews{
    [super layoutSubviews];
    if( self.dataSource && self.emptyView ){
        NSInteger totalNum = 0;
        NSInteger numOfSection = 1;
        if( [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ){
            numOfSection = [self.dataSource numberOfSectionsInTableView:self];
        }
        for( NSInteger section = 0 ;section < numOfSection ; section++ ){
            NSInteger numOfRow = [self.dataSource tableView:self numberOfRowsInSection:section];
            totalNum += numOfRow;
        }
        if( !totalNum
           &&  _startLoading
           && (!_refreshControl || _refreshControl.hidden)
           && (!_footerView ||  _footerView.hidden) ){
            self.emptyView.hidden = NO;
            self.emptyView.centerX = self.width/2;
            CGFloat top = 0;
            if( self.tableHeaderView ){
                top += self.tableHeaderView.bottom;
            }
            if( [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
                for( NSInteger i = 0 ;i < numOfSection ;i ++ ){
                    UIView *v = [self.delegate tableView:self viewForHeaderInSection:i];
                    top += v.height;
                }
            }
            if( [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)] ){
                for( NSInteger i = 0 ;i < numOfSection ;i ++ ){
                    UIView *v = [self.delegate tableView:self viewForFooterInSection:i];
                    top += v.height;
                }
            }
            top += self.emptyViewTopPadding;
            self.emptyView.top = top;
            [self.emptyView bringSubviewToFront:self];
        }else{
            self.emptyView.hidden = YES;
        }
    }
    //    _activityView.centerX = self.centerX;
    //    _activityView.top = self.tableHeaderView.bottom + 10;
}


#pragma mark  - #pragma mark - header & footer refreshing

- (void) startLoading{
    _startLoading = YES;
    self.loading = YES;
   [_refreshControl removeFromSuperview];
    [self setNeedsLayout];
}

- (void) stopLoading{
    [self stopRefreshingAndLoading];
}

- (void) stopRefreshingAndLoading{
    if( _refreshControl && !_refreshControl.superview ){
        [self addSubview:_refreshControl];
    }

    [_refreshControl endRefreshing];
    if( _footerView && !_footerView.hidden ){
        [UIView animateWithDuration:0.25 animations:^{
            [self setSuperContentInset:_userContentEdgeInsets];
        }];
       
        _footerView.hidden = YES;
       
    }
    
    self.loading = NO;
}


- (void) setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
    _userContentEdgeInsets = contentInset;
}

- (void) setSuperContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
}

- (void) contentOffsetChanged:(CGPoint)contentOffset{
    //判断是向下划
    if( _startDragY >= 0 && _footerView.hidden && self.isDragging && contentOffset.y - _startDragY > 30){
        CGFloat margin = self.footerRefresingBeginBottmMarign?self.footerRefresingBeginBottmMarign:DTableViewDefaultBottmRefreshingMargin;
        
        if( self.contentOffset.y + self.height + margin >= self.contentSize.height){
            [self onFooterRefreshing];
            _startDragY = -1;
        }
    }
}

- (void) onRefreshControl:(UIRefreshControl*)refreshControl{
    if( refreshControl.refreshing ){
        self.loading = YES;
        for( DTableViewRefreshCallBack callBack in _headerCallBacks ){
            callBack();
        }
    }
}



- (void) headerEndRefreshing{
    [self stopRefreshingAndLoading];
}

- (void) onFooterRefreshing{
    NSTimeInterval now = CACurrentMediaTime();
    //底部刷新条件：1)footerView当前未显示 2)离上次底部刷新时间超过0.5s
    if( _footerView.hidden && (now - _lastFooterRefreshTime) > 0.5 ){
        _lastFooterRefreshTime = now;
        self.loading = YES;
        _footerView.hidden = NO;
        if( _footerView.superview != self ){
            [self addSubview:_footerView];
        }
        UIEdgeInsets insets = self.contentInset;
        [UIView animateWithDuration:0.25 animations:^{
            [self setSuperContentInset:UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + 30, insets.right)];
        }];
        //修改1,insets.top 去掉
        _footerView.frame = CGRectMake(0, self.contentSize.height /*+ insets.bottom + insets.top*/, self.width, 30);
       
    
        for( DTableViewRefreshCallBack callBack in _footerCallBacks ){
            callBack();
        }
    }
}

- (void) footerEndRefreshing{
    [self stopRefreshingAndLoading];
}


- (void) addFooterWithCallback:(DTableViewRefreshCallBack)callBack{
    if( !_footerView ){
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _footerView.hidden = YES;
    }
    if( !_footerCallBacks ){
        _footerCallBacks = [NSMutableArray new];
    }
    if (!_footerCallBacks.count) {
        [_footerCallBacks addObject:callBack];
    }
   
}

- (void) addFooterWithTarget:(id)target action:(SEL)action{
    __weak id weakRef = target;
    DTableViewRefreshCallBack callBack = ^(void){
        __strong id strongRef = weakRef;
        if( [strongRef respondsToSelector:action] ){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongRef performSelector:action withObject:nil];
#pragma clang diagnostic pop
        }
    };
    [self addFooterWithCallback:callBack];
}

- (void) removeHeader{
    if( _refreshControl ){
        [_refreshControl removeFromSuperview];
        _refreshControl = nil;
    }
    [_headerCallBacks removeAllObjects];
}

- (void) removeFooter{
    if( _footerView ){
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    [_footerCallBacks removeAllObjects];
  
}

@end
