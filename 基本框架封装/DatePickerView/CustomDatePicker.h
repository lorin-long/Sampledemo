//
//  CustomDatePicker.h
//  基本框架封装
//
//  Created by lorin on 16/5/19.
//  Copyright © 2016年 lorin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic)int year;
@property(nonatomic)int month;
@property(nonatomic)int day;

@end
