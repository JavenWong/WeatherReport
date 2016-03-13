//
//  UseViewController.m
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "UseViewController.h"
#import "GongGaoViewController.h"
#import "myHealthViewController.h"
#import "NewsViewController.h"
#import "SetUpTableViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface UseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *userArr;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *titleArr;

@property (nonatomic,strong)UIImage *userImage;

@property (nonatomic,strong)NSMutableArray *imageArr1;

@property (nonatomic,strong)NSMutableArray *imageArr2;

@end

@implementation UseViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight/3.2, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self getdata];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3.2)];
    imageV.image = [UIImage imageNamed:@"tianqi.jpg"];
    [self.view addSubview:imageV];
    
    
}

- (void)tap{
    GongGaoViewController *gonggao = [[GongGaoViewController alloc]init];
    [self.navigationController pushViewController:gonggao animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getdata{
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"我的健康",nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"穿衣助手",@"空气果", nil];
    NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:@"新闻",@"设置", nil];
    self.userArr = [NSMutableArray arrayWithObjects:arr1,arr2,arr3, nil];
    self.titleArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.userArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    self.imageArr1 = [NSMutableArray array];
    self.imageArr2 = [NSMutableArray array];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    NSMutableArray *arr = self.userArr[indexPath.section];
    NSString *name = arr[indexPath.row];
    cell.textLabel.text = name;
    for (int i = 2; i < 4; i++) {
        NSString *str1 = [NSString stringWithFormat:@"%d.png",i];
        UIImage *userImage1 = [UIImage imageNamed:str1];
        [self.imageArr1 addObject:userImage1];
        
    }
    for (int i = 4; i < 6; i++) {
        NSString *str2 = [NSString stringWithFormat:@"%d.png",i];
        UIImage *userImage2 = [UIImage imageNamed:str2];
        [self.imageArr2 addObject:userImage2];
    }
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"1.png"];
    }else if(indexPath.section == 1){
        cell.imageView.image = self.imageArr1[indexPath.row];
    }else if(indexPath.section == 2){
        cell.imageView.image = self.imageArr2[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArr[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            myHealthViewController *myHealth = [[myHealthViewController alloc]init];
            [self.navigationController pushViewController:myHealth animated:YES];
            break;
        }
        case 1:{
            if (indexPath.row == 0) {
               
            }else{
                
            }
            
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                NewsViewController *news = [[NewsViewController alloc]init];
                [self.navigationController pushViewController:news animated:YES];
            }else{
                SetUpTableViewController *vc = [[SetUpTableViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        default:
            break;
        }
            
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
