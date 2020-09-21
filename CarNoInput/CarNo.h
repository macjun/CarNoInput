//
//  CarNo.h
//  CarNoInput
//
//  Created by machaojun on 2020/9/17.
//  Copyright © 2020 machaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectCodeBlock)(NSString *);
@interface CarNo : UIView
@property(nonatomic,copy)SelectCodeBlock CodeBlock;
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,assign)NSInteger inputNum;//验证码输入个数（4或6个）
- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock;
- (void)deleteAllData;

@end

NS_ASSUME_NONNULL_END
