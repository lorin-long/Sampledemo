//
//  CYLHomeViewController.m
//  基本框架封装
//
//  Created by lorin on 16/5/10.
//  Copyright © 2016年 lorin. All rights reserved.
//

#import "CYLHomeViewController.h"
#import "UIColor+KSString.h"
#import "PassWordView.h"
#import "ViewController.h"
#import "LJAlertView.h"
#import "QRReaderViewController.h"
#import "CustomDatePicker.h"
#import "JXAlertview.h"
#import "CityViewController.h"
@interface CYLHomeViewController ()<LJAlertViewDelegate,QRReaderViewControllerDelegate,CustomAlertDelegete,UITextFieldDelegate>
  {
        UITextField *dateText;
        CustomDatePicker * Dpicker;
    }


@end

@implementation CYLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:@"付款框" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor cyanColor];
    btn.frame=CGRectMake(50, 100, 100, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(didBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn1=[[UIButton alloc]init];
    btn1.backgroundColor=[UIColor getColor:@"2DBEE6"];
    [btn1 setTitle:@"自定义提示框" forState:UIControlStateNormal];
    btn1.frame=CGRectMake(50, 150, 200, 30);
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(didBtn1) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2=[[UIButton alloc]init];
    btn2.backgroundColor=[UIColor orangeColor];
    [btn2 setTitle:@"二维码" forState:UIControlStateNormal];
    btn2.frame=CGRectMake(50, 200, 200, 30);
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(didBtn2) forControlEvents:UIControlEventTouchUpInside];
    dateText=[[UITextField alloc]init];
    dateText.frame=CGRectMake(50, 250, 200, 30);
    dateText.delegate=self;
    dateText.layer.borderWidth=0.5f;
    dateText.layer.cornerRadius=5.0f;
    dateText.placeholder=@"请选择日期";
    dateText.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:dateText];
    UIButton *locateBtn=[[UIButton alloc]init];
    locateBtn.frame=CGRectMake(50, 300, 200, 30);
    locateBtn.backgroundColor=[UIColor orangeColor];
    [locateBtn setTitle:@"地位" forState:UIControlStateNormal];
    [locateBtn addTarget:self action:@selector(didLocated) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locateBtn];
}
-(void)didBtn{
    PassWordView *vc=[[PassWordView alloc]init];
    vc.frame=CGRectMake((self.view.frame.size.width - 250)*0.5, 50,self.view.bounds.size.width- 40, 170);
    [vc setTitleModel:@{@"title": @"请输入密码",@"payName":@"付款金额",@"money":@"200元",@"cardName":@"招商银行"}];
    //避免循环引用
    __weak typeof(vc) temp = vc;
    //判断输入数字是否相同
    vc.block = ^(NSString *str){
        if ([str isEqualToString:@"111111"]) {
             [temp dismiss];
            ViewController *vc=[ViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
           [vc pop];
}
-(void)didBtn1{
        LJAlertView *alterView=[[LJAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [alterView  setTitleModel:@{@"title":@"为了您的账户安全，请设置手势密码",@"ok":@"设置",@"cancel":@"取消"}];
        alterView.delegate=self;
        [self.view addSubview:alterView];
 
}
-(void)alSubmitBtnAction{
 
 
}
-(void)didBtn2{
      QRReaderViewController *VC = [[QRReaderViewController alloc] init];
      VC.delegate = self;
      [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - QRReaderViewControllerDelegate

- (void)didFinishedReadingQR:(NSString *)string {
    NSLog(@"result string: %@", string);
    NSURL * url = [NSURL URLWithString: string];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"警告" message: [NSString stringWithFormat: @"%@", @"无法解析的二维码"] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    Dpicker = [[CustomDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-20, 200)];
    JXAlertview *alert = [[JXAlertview alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height-260)/2, self.view.frame.size.width-20, 260)];
    //alert.image = [UIImage imageNamed:@"dikuang"];
    alert.delegate = self;
    [alert initwithtitle:@"请选择日期" andmessage:@"" andcancelbtn:@"取消" andotherbtn:@"确定"];
    [alert addSubview:Dpicker];
    [alert show];
    
    return NO;
}
-(void)btnindex:(int)index :(int)tag
{
    if (index == 2) {
        dateText.text = [NSString stringWithFormat:@"%d年%d月%d日",Dpicker.year,Dpicker.month,Dpicker.day];
        [dateText resignFirstResponder];
    }
}
-(void)didLocated{
    CityViewController *cityView=[CityViewController new];
    [self.navigationController pushViewController:cityView animated:YES];
}
@end
