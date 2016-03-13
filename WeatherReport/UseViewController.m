//
//  UseViewController.m
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "UseViewController.h"
#import "DataManager.h"
#import "User.h"
@interface UseViewController ()

@property (nonatomic,strong)NSMutableArray *userArr;

@end

@implementation UseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getdata];
    }
    return self;
}

- (void)getdata{
    self.userArr = [NSMutableArray array];
    DataManager *data = [DataManager sharedManager];
    User *user1 = [[User alloc]initWithHealth:@"我的健康" assit:nil air:nil    account:nil setting:nil];
    User *user2 = [[User alloc]initWithHealth:nil assit:@"穿衣助手" air:nil account:nil setting:nil];
    User *user3 = [[User alloc]initWithHealth:nil assit:nil air:@"空气果" account:nil setting:nil];
    User *user4 = [[User alloc]initWithHealth:nil assit:nil air:nil account:@"社交账号" setting:nil];
    User *user5 = [[User alloc]initWithHealth:nil assit:nil air:nil account:nil setting:@"设置"];
    [data openData];
    [data closeData];
    [data addUser:user1];
    [data addUser:user2];
    [data addUser:user3];
    [data addUser:user4];
    [data addUser:user5];
    NSArray *arr = @[user1,user2,user3,user4,user5];
    [self.userArr addObjectsFromArray:arr];
    
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
