//
//  DTextView.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/12.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//------ 完成编辑 -----//
typedef void (^TextViewDidEndEditingBlock)(NSString *text);


@interface DTextView : UIView

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel    *placeholderLabel;
@property (nonatomic, strong) TextViewDidEndEditingBlock textViewDidEndEditingBlock;


@end




@interface TCTextView : UITextView<UITextViewDelegate>

- (void) setAutoHeight:(NSLayoutConstraint*)heightConstaint minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;

@property (nonatomic) NSString* placehold;

@property (nonatomic) CGFloat placeholdLeftPadding;

@property (nonatomic) UILabel * placeholdLabel;

@end

NS_ASSUME_NONNULL_END
