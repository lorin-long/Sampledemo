//
//  CityViewController.h
//  基本框架封装
//
//  Created by lorin on 16/5/20.
//  Copyright © 2016年 lorin. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol CityViewControllerDelegete <NSObject>

-(void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation;

@end
@interface CityViewController : UIViewController<UISearchBarDelegate,  UITableViewDataSource, UITableViewDelegate>
{
    UILabel * lable;
    UIButton * button;
}
@property(nonatomic, strong) NSMutableArray * ChineseCities;//存放所有未排序的城市信息
@property (nonatomic, strong) UISearchBar *searchBar;//搜索框
@property (nonatomic, strong) NSMutableArray *cities;//存放未处理所有城市
@property(nonatomic, strong) NSMutableArray * fixArray;//存放纯城市信息
@property(nonatomic, strong) NSMutableArray * tempArray;//中间数组
@property(nonatomic, strong) NSMutableArray * letters;//存放开头字母
@property(nonatomic, strong) UITableView * table;// 展示列表
@property(nonatomic, strong) NSString * loctionCity;//定位城市
@property(nonatomic, assign) BOOL isSearch;//是否是search状态
@property(nonatomic, assign) id<CityViewControllerDelegete>delegete;

@end
