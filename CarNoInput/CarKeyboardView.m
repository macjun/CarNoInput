//
//  CarKeyboardView.m
//  ITMC_CLIENT
//
//  Created by sn17112519 on 2019/8/23.
//  Copyright © 2019 wxhan. All rights reserved.
//

#import "CarKeyboardView.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CURSRCEENLENGTH(iphone6length)     iphone6length * [UIScreen mainScreen].bounds.size.width / 375
#define kDevice_Is_iPhoneX     ([UIScreen instancesRespondToSelector:@selector(currentMode)]? (CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen]currentMode].size) || CGSizeEqualToSize(CGSizeMake(750, 1624),[[UIScreen mainScreen]currentMode].size)):NO)
#define SafeArearBottomHeight  (kDevice_Is_iPhoneX? 38:0) //iPhoneX 底部的空白高度
@interface CarKeyboardView()
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *alphaNumArray;
@property (nonatomic, strong) UIView *provincesView;
@property (nonatomic, strong) UIView *alphaNumView;

@end


@implementation CarKeyboardView

- (instancetype)initWithFrame:(CGRect)frame type:(CarKeyboardFromType)type {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.fromType = type;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    //省份键盘
    _provincesView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, size.width, CURSRCEENLENGTH(216))];
    _provincesView.backgroundColor = UIColorFromHex(0xc4cdd2);
    _provincesView.hidden = NO;
    //数子和英文键盘
    _alphaNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, size.width, CURSRCEENLENGTH(216))];
    _alphaNumView.hidden = YES;
    _alphaNumView.backgroundColor = UIColorFromHex(0xc4cdd2);
    
    [self addSubview:_provincesView];
    [self addSubview:_alphaNumView];
    
    int row = 4;
    int column = 10;
    CGFloat btnY = CURSRCEENLENGTH(10);
    CGFloat btnX = CURSRCEENLENGTH(10);
    CGFloat maginR = CURSRCEENLENGTH(6);
    CGFloat maginC = CURSRCEENLENGTH(8);
    CGFloat btnW = (size.width - maginR * (column -1) - 2 * btnX)/column;
    CGFloat btnH = (_provincesView.frame.size.height - maginC * (row - 1)-btnY*2) / row;
    for (int i = 0; i < self.provinceArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
        btn.backgroundColor=UIColorFromHex(0xffffff);
        [btn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [btn setTitle:self.provinceArray[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(carKeyBoardProvinceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_provincesView addSubview:btn];
    }
    
    for (int i = 0; i < self.alphaNumArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==self.alphaNumArray.count-1) {
            CGFloat width = btnW*3+2*maginR;
            if (_fromType == CarKeyboardFromTypeCarIden) {
                width = btnW*2+maginR;
            }
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), width, btnH);
             [btn setBackgroundImage:[self createImageWithColor:UIColorFromHex(0x3478f6)] forState:UIControlStateNormal];
             [btn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        }else{
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
            [btn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
            if (i==29) {
                btn.backgroundColor=UIColorFromHex(0xb6bac6);
                [btn setImage:[UIImage imageNamed:@"ic_keyboard_delete"] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[self createImageWithColor:UIColorFromHex(0xffffff)] forState:UIControlStateNormal];
                [btn setBackgroundImage:[self createImageWithColor:UIColorFromHex(0xdcdfe6)] forState:UIControlStateDisabled];
            }
        }
        if (i==17 || i==18) {
            btn.enabled=NO;
            [btn setTitleColor:UIColorFromHex(0xc4cdd2) forState:UIControlStateNormal];
        }else{
            btn.enabled=YES;
        }
        [btn setTitle:self.alphaNumArray[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(carKeyBoardAlphaNumClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alphaNumView addSubview:btn];
    }
    
    //弹出省份键盘
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.provincesView.frame;
        frame.origin.y = self.frame.size.height - CURSRCEENLENGTH(216) - SafeArearBottomHeight;
        self.provincesView.frame = frame;
    }];
    //弹出数字英文键盘
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.alphaNumView.frame;
        frame.origin.y = self.frame.size.height - CURSRCEENLENGTH(216) - SafeArearBottomHeight;
        self.alphaNumView.frame = frame;
    }];
}


-(void)setCarKeyBoardType:(CarKeyboardViewType)carKeyBoardType
{
    _carKeyBoardType=carKeyBoardType;
    if (carKeyBoardType==CarKeyboardViewTypeProvince) {
        _alphaNumView.hidden=YES;
        _provincesView.hidden=NO;
    }else if (carKeyBoardType==CarKeyboardViewTypeAlphaNum){
        _alphaNumView.hidden=NO;
        _provincesView.hidden=YES;
    }
}

- (void)carKeyBoardAlphaNumClick:(UIButton *)sender {
      if (_provincesView.hidden) {
          if (sender.tag == 29){//点击删除
              if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
                  [self.delegate deleteBtnClick:CarKeyboardViewTypeAlphaNum];
              }
          }else if ([sender.currentTitle isEqualToString:@"确认"])//确认
          {
              if(self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnClick)])
              {
                  [self.delegate confirmBtnClick];
              }
              
          }else{
              if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:keyBoardType:)]) {
                  [self.delegate clickWithString:self.alphaNumArray[sender.tag] keyBoardType:CarKeyboardViewTypeAlphaNum];
              }
          }
      }
}

- (void)carKeyBoardProvinceClick:(UIButton *)sender {
    
    if (_alphaNumView.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:keyBoardType:)]) {
            [self.delegate clickWithString:self.provinceArray[sender.tag] keyBoardType:CarKeyboardViewTypeProvince];
        }
    }
}

#pragma mark getter && setter
- (NSArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"琼",@"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",@"桂",@"宁",@"新",@"藏",@"使",@"领",@"警",@"学",@"港",@"澳",@"台"];
    }
    return _provinceArray;
}

- (NSArray *)alphaNumArray {
    if (!_alphaNumArray) {
        if (_fromType == CarKeyboardFromTypeCarIden) {
            _alphaNumArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"挂",@"确认"];
        } else {
            _alphaNumArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"确认"];
        }
    }
    return _alphaNumArray;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    //设置长宽
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f, 5.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
