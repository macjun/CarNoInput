//
//  CarNo.m
//  CarNoInput
//
//  Created by machaojun on 2020/9/17.
//  Copyright © 2020 machaojun. All rights reserved.
//

#import "CarNo.h"
#import "CarKeyboardView.h"

#define K_W 30

@interface CarNo()<UITextViewDelegate, CarKeyBoardViewDelegate>
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;

@property (strong, nonatomic) CarKeyboardView *keyboardView;
@end

@implementation CarNo

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.CodeBlock = CodeBlock;
        self.inputNum = inputNum;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat Padd = (W-self.inputNum*K_W)/(self.inputNum+1);
    [self addSubview:self.textView];
    self.textView.frame = CGRectMake(Padd, 0, W-Padd*2, H);
    for (int i = 0; i < _inputNum; i ++) {
        UIView *subView = [UIView new];
        subView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        if (i == 6) {
            subView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:235.0/255.0 blue:199.0/255.0 alpha:1];
        }
        subView.frame = CGRectMake(Padd+(K_W+Padd)*i, 0, K_W, H);
        subView.layer.masksToBounds = YES;
        subView.layer.cornerRadius = 2;
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        //Label
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, K_W, H);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:16];
        [subView addSubview:label];
        [self.labels addObject:label];
    }
    
    //默认编辑第一个
//    [self beginEdit];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = textView.text;
    if (verStr.length > _inputNum) {
        textView.text = [textView.text substringToIndex:_inputNum];
    }
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
        [self endEdit];
    }
    if (self.CodeBlock) {
        self.CodeBlock(textView.text);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self changeViewLayerIndex:self.textView.text.length linesHidden:NO];
}

//设置当前输入边框
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    if (index < self.labels.count) {
        UIView* subview = self.labels[index];
        if (hidden) {
            subview.layer.borderWidth = 0;
            subview.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            subview.layer.borderWidth = 1;
            subview.layer.borderColor = [UIColor colorWithRed:52.0/255 green:120.0/255 blue:246.0/255 alpha:1].CGColor;
        }
    }
    
}
//开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
    [self changeViewLayerIndex:self.textView.text.length linesHidden:NO];
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
    [self changeViewLayerIndex:self.textView.text.length linesHidden:YES];
}

- (void)deleteAllData {
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
    [self.textView becomeFirstResponder];
//    [self endEdit];
//    for (int i = 0; i < _labels.count; i ++) {
//        UILabel *bgLabel = _labels[i];
//        bgLabel.text = @"";
//    }
}


// MARK:keyboard delegate
- (void)clickWithString:(NSString *)string keyBoardType:(CarKeyboardViewType)keyboardType {
    self.textView.text = [self.textView.text stringByAppendingString:string];
    [self textViewDidChange:self.textView];
}

- (void)confirmBtnClick {
    [self endEdit];
}

- (void)deleteBtnClick:(CarKeyboardViewType)keyboardType {
    if (self.textView.text.length) {
        self.textView.text = [self.textView.text substringToIndex:[self.textView.text length] - 1];
        [self textViewDidChange:self.textView];
    }
}


// MARK:lazy loading
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.inputView = self.keyboardView;
        _textView.font = [UIFont systemFontOfSize:0];
        self.keyboardView.carKeyBoardType = CarKeyboardViewTypeAlphaNum;
    }
    return _textView;
}


- (CarKeyboardView*)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = [[CarKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240 * [UIScreen mainScreen].bounds.size.width / 375) type:CarKeyboardFromTypeCarRegister];
        _keyboardView.delegate = self;
    }
    return _keyboardView;
}


@end
