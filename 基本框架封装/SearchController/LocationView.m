//
//  LocationView.m
//  基本框架封装
//
//  Created by lorin on 16/5/22.
//  Copyright © 2016年 lorin. All rights reserved.
//

#import "LocationView.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationView()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    UILabel *longitudeLabel;
    UILabel *latitudeLabel;
    
}
@end

@implementation LocationView
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initializeLocationService];
    longitudeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 74, 200, 30)];
    longitudeLabel.layer.borderWidth=0.5f;
    [self.view addSubview:longitudeLabel];
    latitudeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 30)];
    latitudeLabel.layer.borderWidth=0.5f;
    [self.view addSubview:latitudeLabel];
    // Do any additional setup after loading the view.
}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager requestAlwaysAuthorization];
    // 开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //将经度显示到label上
    longitudeLabel.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    latitudeLabel.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
           longitudeLabel.text = placemark.name;
            //获取城市
              _city = placemark.locality;
            if (!_city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                _city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", _city);
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
@end
