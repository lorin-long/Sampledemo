//
//  City.h
//  基本框架封装
//
//  Created by lorin on 16/5/20.
//  Copyright © 2016年 lorin. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface City : NSObject
@property(nonatomic,strong) NSString * cityNAme;//城市名称 
@property(nonatomic,strong) NSString * letter;//城市拼音
@property(nonatomic, assign) float latitude;//纬度
@property(nonatomic, assign) float longtitde;//经度
@end
