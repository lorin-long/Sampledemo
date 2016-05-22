//
//  CityViewController.m
//  基本框架封装
//
//  Created by lorin on 16/5/20.
//  Copyright © 2016年 lorin. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#import "CityViewController.h"
#import "City.h"
#import "HandleCityData.h"
#import "Masonry.h"
#import "LocationView.h"
@interface CityViewController ()
@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initDataArray
{
    self.letters = [[NSMutableArray alloc] init];
    self.fixArray = [[NSMutableArray alloc] init];
    self.tempArray = [[NSMutableArray alloc] init];//search出来的数据存放
    self.ChineseCities = [[NSMutableArray alloc] init];
    HandleCityData * handle = [HandleCityData shareHandle];
    NSArray * cityInforArray = [handle cityDataDidHandled];
    [self.letters addObjectsFromArray:[cityInforArray objectAtIndex:0]];//存放所有section字母
    [self.fixArray addObjectsFromArray:[cityInforArray objectAtIndex:1]];//存放所有城市信息数组嵌入数组和字母匹配
    [self.ChineseCities addObjectsFromArray:[cityInforArray objectAtIndex:2]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isSearch = NO;
    [self initDataArray];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initSearchBar];
    self.navigationItem.title=@"选择城市";
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"定位" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_searchBar.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    lable = [[UILabel alloc] init];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(180, 30));
    }];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(lable.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
//    if (self.loctionCity) {
//        lable.text = [NSString stringWithFormat:@"定位城市:%@",self.loctionCity];
//    }else{
//        lable.text = @"定位失败，请重新定位";
//    }
    self.table.dataSource = self;
    self.table.delegate = self;

	// Do any additional setup after loading the view.
}
#pragma mark - Initialization

- (void)initSearchBar
{
    _searchBar = [[UISearchBar alloc] init];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"城市名称";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(44.f);
    }];
    
}
#pragma mark tableViewDelegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.letters.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.tempArray.count;
    }
    NSArray * letterArray = [self.fixArray objectAtIndex:section];//对应字母所含城市数组
    return letterArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    return [self.letters objectAtIndex:section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.isSearch) {
        return 1;
    }
    NSLog(@"%ld",index);
    return index;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    City * city;
    if (self.isSearch) {
        city = [self.tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
    }else{
        NSArray * letterArray = [self.fixArray objectAtIndex:indexPath.section];//对应字母所含城市数组
        city = [letterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [_delegete cityViewdidSelectCity:cell.textLabel.text anamation:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark searchBarDelegete
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tempArray removeAllObjects];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (City * city in self.ChineseCities) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [self.tempArray addObject:city];
            }else if (letters.location != NSNotFound){
                [self.tempArray addObject:city];
            }
        }
    }
    [self.table reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}
-(void)locationClick{
    LocationView *vc=[LocationView new];
//    self.loctionCity=vc.city;
//    NSLog(@"aaaaa");
    if (self.loctionCity) {
        lable.text =vc.city;
        NSLog(@"%@",vc.city);
    }else{
        lable.text = @"定位失败，请重新定位";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
