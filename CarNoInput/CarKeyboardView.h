//
//  CarKeyboardView.h
//  ITMC_CLIENT
//
//  Created by sn17112519 on 2019/8/23.
//  Copyright © 2019 wxhan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CarKeyboardViewType) {
    CarKeyboardViewTypeProvince=0,
    CarKeyboardViewTypeAlphaNum
};

typedef NS_ENUM(NSUInteger, CarKeyboardFromType) {
    CarKeyboardFromTypeCarRegister=0,
    CarKeyboardFromTypeCarIden,
};

@protocol CarKeyBoardViewDelegate <NSObject>
//选择输入
- (void)clickWithString:(NSString *)string keyBoardType:(CarKeyboardViewType)keyboardType;
//点击删除
- (void)deleteBtnClick:(CarKeyboardViewType)keyboardType;
//点击确认
-(void)confirmBtnClick;

@end

@interface CarKeyboardView : UIView

@property (nonatomic, weak) id<CarKeyBoardViewDelegate> delegate;
@property (nonatomic,assign) CarKeyboardViewType carKeyBoardType;

@property (nonatomic, assign) CarKeyboardFromType fromType;


- (instancetype)initWithFrame:(CGRect)frame type:(CarKeyboardFromType)type;


@end

NS_ASSUME_NONNULL_END
