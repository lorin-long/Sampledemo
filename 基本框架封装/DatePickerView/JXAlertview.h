//
//  JXAlertview.h
//  基本框架封装
//
//  Created by lorin on 16/5/19.
//  Copyright © 2016年 lorin. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol CustomAlertDelegete <NSObject>

-(void)btnindex:(int)index :(int) tag;

@end
@interface JXAlertview : UIImageView
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *message;
@property(nonatomic,retain)UIButton *cancelbtn;
@property(nonatomic,retain)UIButton *surebtn;
@property (nonatomic,retain) id<CustomAlertDelegete> delegate;
-(void)initwithtitle:(NSString *)str andmessage:(NSString *)str1 andcancelbtn:(NSString *)cancel andotherbtn:(NSString *)other;
-(void)show;
-(void)showview;
-(void)dismmis;

@end
