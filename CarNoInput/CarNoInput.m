//
//  CarNoInput.m
//  CarNoInput
//
//  Created by machaojun on 2020/9/17.
//  Copyright © 2020 machaojun. All rights reserved.
//

#import "CarNoInput.h"
#import "CarNo.h"
#import "CarKeyboardView.h"

@interface CarNoInput()<UITextFieldDelegate ,CarKeyBoardViewDelegate>

@property (nonatomic, strong) CarKeyboardView *keyboardView;

@property (nonatomic, strong) CarNo* carNo;

@property (nonatomic, strong) UITextField* areaTF;

@property (nonatomic, strong) UIButton* delBtn;

@end

@implementation CarNoInput

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withCarNoInputType:(CarNoInputType)carNoInputType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.carNoInputType = carNoInputType;
    }
    return self;
}

- (void)setCarNoInputType:(CarNoInputType)carNoInputType {
    _carNoInputType = carNoInputType;
    [self configUI];
}

- (void)configUI {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addSubview:self.areaTF];
    self.areaTF.frame = CGRectMake(10, 0, 35, self.bounds.size.height);

    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_ic_arrow03.png"]];
    [self.areaTF addSubview:arrowImage];
    arrowImage.frame = CGRectMake(CGRectGetMaxX(self.areaTF.frame) - 20, (self.bounds.size.height - 6)/2, 12, 6);
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
    [self addSubview:lineView];
    lineView.frame = CGRectMake(CGRectGetMaxX(self.areaTF.frame)+5, 6, 1, self.bounds.size.height-12);
    
    NSInteger count = self.carNoInputType == CarNoInputTypeTrailer ? 5 : 7;
    
    __weak typeof(self) weakSelf = self;
    CarNo* carNo = [[CarNo alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 10, 0, count*33+3, self.bounds.size.height) inputType:count selectCodeBlock:^(NSString * _Nonnull str) {
        weakSelf.delBtn.hidden = !str.length;
        [weakSelf completeBlock];
    }];
    self.carNo = carNo;
    [self addSubview:carNo];
    
    [self addSubview:self.delBtn];
    
    if (self.carNoInputType == CarNoInputTypeTrailer) {
        UILabel* guaLab = [UILabel new];
        [self addSubview:guaLab];
        guaLab.text = @"挂";
        guaLab.font = [UIFont systemFontOfSize:16];
        guaLab.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        guaLab.frame =  CGRectMake(CGRectGetMaxX(carNo.frame) + 5, 0, 30, self.bounds.size.height);
        
        self.delBtn.frame = CGRectMake(CGRectGetMaxX(guaLab.frame) + 5, (self.bounds.size.height - 20)/2, 20, 20);
    } else {
        self.delBtn.frame = CGRectMake(CGRectGetMaxX(carNo.frame) + 5, (self.bounds.size.height - 20)/2, 20, 20);
    }
    
}

- (void)completeBlock {
    BOOL isComplete = NO;
    NSString* province = self.areaTF.text;
    NSString* alpNo = self.carNo.textView.text;
    NSString* carNo = [NSString stringWithFormat:@"%@%@",province,alpNo];
    if (self.carNoInputType == CarNoInputTypeTrailer) {
        isComplete = (province.length == 1 && alpNo.length == 5);
        carNo = [NSString stringWithFormat:@"%@挂",carNo];
    } else {
        isComplete = (province.length == 1 && alpNo.length >= 6);
    }
    
    if (self.editHandle) {
        self.editHandle(isComplete, province, alpNo, carNo);
    }
}

- (void)didTouchDelBtn {
    [self.carNo deleteAllData];
//    [self completeBlock];
}


// MARK:keyboard delegate
- (void)clickWithString:(NSString *)string keyBoardType:(CarKeyboardViewType)keyboardType {
    self.areaTF.text = string;
    [self.areaTF resignFirstResponder];
    [self completeBlock];
}

- (void)confirmBtnClick {
    [self.areaTF resignFirstResponder];
}



// MARK:lazy loading
- (UITextField *)areaTF {
    if (!_areaTF) {
        _areaTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _areaTF.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        _areaTF.font = [UIFont systemFontOfSize:16];
        _areaTF.delegate = self;
        _areaTF.inputView = self.keyboardView;
        [_areaTF setTintColor:[UIColor clearColor]];
        
        self.keyboardView.carKeyBoardType = CarKeyboardViewTypeProvince;
    }
    return _areaTF;
}


- (CarKeyboardView*)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = [[CarKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240 * [UIScreen mainScreen].bounds.size.width / 375) type:CarKeyboardFromTypeCarRegister];
        _keyboardView.delegate = self;
    }
    return _keyboardView;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [UIButton new];
        [_delBtn setImage:[UIImage imageNamed:@"ic_delete02.png"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(didTouchDelBtn) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.hidden = YES;
    }
    return _delBtn;
}

@end
