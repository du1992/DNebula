//
//  DTextView.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/12.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DTextView.h"

@interface DTextView()<UITextViewDelegate,UIScrollViewDelegate>
{
   
  
}
@end


@implementation DTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
      return self;
}

- (void)createUI{
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_top).offset(0);
        make.left.mas_equalTo(self.textView.mas_left).offset(0);
        make.height.mas_equalTo(39);
    }];
    
   
    
}



#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    /**
     *  设置占位符
     */
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden=NO;
     
    }else{
        self.placeholderLabel.hidden=YES;
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textViewDidEndEditingBlock) {
        self.textViewDidEndEditingBlock(textView.text);
    }
}


#pragma mark --- 懒加载控件
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        [self addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.textColor = UIColorFromRGBValue(0xb3b3b3);
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}



@end






#define MAX_LIMIT_NUMS  140

@interface TCTextView(){
    
    BOOL _autoHeight;
    NSLayoutConstraint *_heightConstaint;
    CGFloat _minHeight;
    CGFloat _maxHeight;
    
    //    UILabel *_placeholdLabel;
    
    __weak id<UITextViewDelegate> _wrapDelegate;
}

@end

@implementation TCTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    if( self = [super initWithFrame:frame textContainer:textContainer] ){
        [self setUp];
    }
    return self;
}


- (void) setUp{
    [super setDelegate:self];
    self.placeholdLeftPadding = 10;
    self.tintColor = AppAlphaColor(0,0,0,1);
    
    
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (UILabel *)placeholdLabel {
    if( !_placeholdLabel ){
        _placeholdLabel = [UILabel new];
        _placeholdLabel.font = AppFont(15);
        _placeholdLabel.textColor = UIColorFromRGBValue(0xbebdbd);
        _placeholdLabel.frame = CGRectMake(5, 1, kScreenWidth - 50, 30);
        [self addSubview:_placeholdLabel];
    }
    return _placeholdLabel;
}
- (void) setPlacehold:(NSString *)placehold{
    self.placeholdLabel.text = placehold;
    //[_placeholdLabel sizeToFit];
    //_placeholdLabel.left = self.placeholdLeftPadding;
    self.placeholdLabel.hidden = self.text.length;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    //if( !(_placeholdLabel.top) ){
    //   _placeholdLabel.centerY = self.height >= self.font.lineHeight*2?7+_placeholdLabel.height/2:self.height/2;
    //}
}

- (void) setText:(NSString *)text{
    [super setText:text];
    [self textViewDidChange:self];
}

- (NSString*) placehold{
    return self.placeholdLabel.text;
}

- (void) setDelegate:(id<UITextViewDelegate>)delegate{
    _wrapDelegate = delegate;
}

- (void) setAutoHeight:(NSLayoutConstraint*)heightConstaint minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight{
    _autoHeight = YES;
    _heightConstaint = heightConstaint;
    _minHeight = minHeight;
    _maxHeight = maxHeight;
}

- (void) setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    [self autoHeight];
}

- (void) autoHeight{
    if( _autoHeight ){
        CGFloat contentHeight = self.contentSize.height;
        if( contentHeight < _minHeight + _minHeight/2 ){
            contentHeight = _minHeight;
        }else if( contentHeight > _maxHeight){
            contentHeight = _maxHeight;
        }
        if( fabs(_heightConstaint.constant - contentHeight) > 0.1 ){
            self.height = contentHeight;
            if( _heightConstaint ){
                _heightConstaint.constant = contentHeight;
                [self setNeedsUpdateConstraints];
            }
        }
    }
}

- (void) setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if( hidden ){
        _heightConstaint.constant = _minHeight;
    }else{
        [self autoHeight];
    }
}

#pragma mark - textView delegate wrap


#define TCTEXTVIEW_WRAP_DELEGATE(func)\
if( [_wrapDelegate respondsToSelector:@selector(func:)] ){\
return [_wrapDelegate func:textView];\
}\

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewShouldBeginEditing)
    //    _placeholdLabel.frame = CGRectMake(10, 0, _placeholdLabel.width,_placeholdLabel.height);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewShouldEndEditing)
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidBeginEditing)
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidEndEditing)
    //    _placeholdLabel.frame = CGRectMake(10, 0, _placeholdLabel.width, self.height);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] ){
        return [_wrapDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    //如果无文本，显示placeHold
    self.placeholdLabel.hidden = textView.text.length;
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidChange)
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidChangeSelection)
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)] ){
        return [_wrapDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)] ){
        return [_wrapDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return NO;
}

@end
