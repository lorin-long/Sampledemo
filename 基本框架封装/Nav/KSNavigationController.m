//
//KSNavigationController.m
//  基本框架封装
//
//  Created by lorin on 16/5/10.
//  Copyright © 2016年 lorin. All rights reserved.
//

#import "KSNavigationController.h"

@interface KSNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation KSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    //设置NavigationBar
    [self setupNavigationBar];
}

//设置导航栏主题
- (void)setupNavigationBar
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    [appearance setBarTintColor:[UIColor getColor:@"2DBEE6"]];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:textAttribute];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [backButton setImage:[UIImage imageNamed:@"fn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"fn"] forState:UIControlStateHighlighted];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [backButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popView
{
    [self popViewControllerAnimated:YES];
}

//手势代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
