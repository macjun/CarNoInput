# CarNoInput
车牌号输入控件

有2种输入模式，一种为普通车牌号，最后一位为能源车号，另一种为挂车车牌号，通过CarNoInputType属性来控制

创建代码为：
```
CarNoInput* view = [[CarNoInput alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 42)];
[self.view addSubview:view];
view.carNoInputType = CarNoInputTypeNornmal;

view.editHandle = ^(BOOL isComplete, NSString * _Nonnull province, NSString * _Nonnull alpNo, NSString * _Nonnull carNo) {
    NSLog(@"%d--%@--%@--%@",isComplete,province,alpNo,carNo);
};
```

![](https://github.com/macjun/CarNoInput/blob/master/20200918175954245.png)
