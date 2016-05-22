//
//  HandleCityData.m
//  基本框架封装
//
//  Created by lorin on 16/5/20.
//  Copyright © 2016年 lorin. All rights reserved.
//


#import "HandleCityData.h"
#import "City.h"
#import "JsonData.h"
//按字母排序方法
NSInteger nickNameSort(id user1, id user2, void *context)
{
    City *u1,*u2;
    //类型转换
    u1 = (City*)user1;
    u2 = (City*)user2;
    return  [u1.letter localizedCompare:u2.letter];
}

@interface HandleCityData ()

@property (nonatomic,assign) BOOL isDataLoaded;
@property (nonatomic,strong) NSArray *cityArray;

@end

@implementation HandleCityData

-(NSArray *)cityDataDidHandled
{
    if (!_isDataLoaded) {
        _cityArray = [self loadCityData];
        _isDataLoaded = YES;
    }
    return _cityArray;
}

//解析城市信息
-(NSArray *)loadCityData{
    storeCities = [[NSMutableArray alloc] init];
    //读取本地文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"BaiduMap_cityCenter" ofType:@"txt"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *textFile  = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
    //将读取的文件转化为字典
    NSDictionary * result = [JsonData dataJsonDictionary:textFile];
    
    NSArray * keys = [result allKeys];
    //按key取出字典的数据
    for (NSString * key in keys) {
        NSArray * firstArr = [result objectForKey:key];
        //各省份的字典封装
        if ([key isEqualToString:@"provinces"]) {
            for (NSDictionary * city in firstArr) {
                NSArray * cities = [city objectForKey:@"cities"];
                for (NSDictionary * cityDetail in cities) {
                    City * newCity = [[City alloc] init];
                    NSString * degree = [cityDetail objectForKey:@"g"];
                    NSArray * degereArr = [degree componentsSeparatedByString:@","];
                    newCity.longtitde = [[degereArr objectAtIndex:0] doubleValue];
                    newCity.latitude = [[degereArr objectAtIndex:1] doubleValue];
                    newCity.cityNAme = [cityDetail objectForKey:@"n"];
                    //汉字转拼音，比较排序时候用
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:newCity.cityNAme];
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    }
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                        newCity.letter = ms;
                    }
                    //都放在存储数组里
                    [storeCities addObject:newCity];
                }
                
            }
        }else{
            for (NSDictionary * cityDetail in firstArr) {
                City * newCity = [[City alloc] init];
                NSString * degree = [cityDetail objectForKey:@"g"];
                NSArray * degereArr = [degree componentsSeparatedByString:@","];
                newCity.longtitde = [[degereArr objectAtIndex:0] doubleValue];
                newCity.latitude = [[degereArr objectAtIndex:1] doubleValue];
                newCity.cityNAme = [cityDetail objectForKey:@"n"];
                NSMutableString *ms = [[NSMutableString alloc] initWithString:newCity.cityNAme];
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                }
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                    newCity.letter = ms;
                }
                [storeCities addObject:newCity];
            }
        }
    }
    //排序后的数组初始化
    NSArray * newArr = [[NSArray alloc] init];
    //排序
    newArr = [storeCities sortedArrayUsingFunction:nickNameSort context:NULL];
    //分组数组初始化
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    //开头字母初始化
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    for(int index = 0; index < [newArr count]; index++)
    {
        City *chineseStr = (City *)[newArr objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.letter];
        //取首字母
        NSString *sr= [strchar substringToIndex:1];
        //bNSLog(@"%@",sr);        //sr containing here the first character of each string
        //检查数组内是否有该首字母，没有就创建
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            //不存在就添加进去
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] init];
            checkValueAtIndex = NO;
        }
        //有就把数据添加进去
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[newArr objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    NSArray * array = [NSArray arrayWithObjects:_sectionHeadsKeys,arrayForArrays,storeCities, nil];
    return array;
}

//单例
+(HandleCityData *)shareHandle{
    static HandleCityData *_handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [[HandleCityData alloc] init];
        _handle.isDataLoaded = NO;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [_handle cityDataDidHandled];
//        });
    });
    return _handle;
}

@end
