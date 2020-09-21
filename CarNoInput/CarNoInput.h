//
//  CarNoInput.h
//  CarNoInput
//
//  Created by machaojun on 2020/9/17.
//  Copyright © 2020 machaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CarNoInputTypeNornmal,
    CarNoInputTypeTrailer,
} CarNoInputType;

@interface CarNoInput : UIView
 
@property (nonatomic, assign) CarNoInputType carNoInputType;

@property (nonatomic, copy) void(^editHandle)(BOOL isComplete, NSString* province, NSString* alpNo, NSString* carNo);

- (instancetype)initWithFrame:(CGRect)frame withCarNoInputType:(CarNoInputType)carNoInputType;

@end

NS_ASSUME_NONNULL_END
