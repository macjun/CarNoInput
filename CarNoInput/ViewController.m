//
//  ViewController.m
//  CarNoInput
//
//  Created by machaojun on 2020/9/17.
//  Copyright © 2020 machaojun. All rights reserved.
//

#import "ViewController.h"
#import "CarNoInput.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CarNoInput* view = [[CarNoInput alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 42)];
    [self.view addSubview:view];
    view.carNoInputType = CarNoInputTypeNornmal;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        view.carNoInputType = CarNoInputTypeTrailer;
//    });
    
    view.editHandle = ^(BOOL isComplete, NSString * _Nonnull province, NSString * _Nonnull alpNo, NSString * _Nonnull carNo) {
        NSLog(@"%d--%@--%@--%@",isComplete,province,alpNo,carNo);
    };
    
}


@end
