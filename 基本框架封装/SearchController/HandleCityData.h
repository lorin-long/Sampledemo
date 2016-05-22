//
//  HandleCityData.h
//  基本框架封装
//
//  Created by lorin on 16/5/20.
//  Copyright © 2016年 lorin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface HandleCityData : NSObject
{
    NSMutableArray * storeCities;//存放所有封装好的城市信息，未排序
    NSMutableArray * _sectionHeadsKeys;//存放所有城市的开头字母，相同剔除
}
-(NSArray *)cityDataDidHandled;//数组存三个数组，第一个存放所有的字母，第二个存分类数组,第三个数组存放所有城市信息

+(HandleCityData *)shareHandle;

@end
