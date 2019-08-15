//
//  JHSlider.h
//  JHKit
//
//  Created by HaoCold on 2017/12/25.
//  Copyright © 2017年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>

/// A subclass of UISlider which can tracking current value.
@interface JHSlider : UISlider

#pragma mark - tracking

/// a label to show self.value and tracking the Thumb.
@property (nonatomic,  strong,  readonly) UILabel *trackingLabel;

/// a view as trackingLabel's backgroundView, also tracking the Thumb.
/// default frame is CGRectZero.
@property (nonatomic,  strong,  readonly) UIView *trackingBackgroundView;

/// format for self.value, like @"%.2f",@"%.0f%%" etc.
@property (nonatomic,    copy) NSString *trackingLabelTextFormat;

/// default is 0.
/// the offsetX between trackingBackgroundView centerX and trackingLabel centerX if trackingBackgroundView is not hidden. otherwise, is Thumb centerX and trackingLabel centerX.
/// + is right, - is left.
@property (nonatomic,  assign) CGFloat  trackingLabelOffsetX;

/// default is 10. the distance between Thumb and trackingLabel.
@property (nonatomic,  assign) CGFloat  trackingLabelOffsetY;

/// default is 0.
/// the offsetX between Thumb centerX and trackingBackgroundView centerX.
/// + is right, - is left.
@property (nonatomic,  assign) CGFloat  trackingBackgroundViewOffsetX;

/// default is 10. the distance between Thumb and trackingBackgroundView.
@property (nonatomic,  assign) CGFloat  trackingBackgroundViewOffsetY;


#pragma mark - left views

// about below four view's frame, you should only modify frame.origin.x and frame.size.width if need.

/// a label to show minimumValue.
/// default is hide.
@property (nonatomic,  strong,  readonly) UILabel *leftLabel;

/// a view to show image etc.
/// default is hide.
@property (nonatomic,  strong,  readonly) UIView *leftView;

#pragma mark - right views

/// a label to show maximumValue.
/// default is hide.
@property (nonatomic,  strong,  readonly) UILabel *rightLabel;

/// a view to show image etc.
/// default is hide.
@property (nonatomic,  strong,  readonly) UIView *rightView;

//透明度
@property (nonatomic, copy) void (^transparencyUpdateTata) (NSInteger transparency);


@end
