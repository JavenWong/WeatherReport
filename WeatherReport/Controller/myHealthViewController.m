//
//  myHealthViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/3.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "myHealthViewController.h"
#import "ModifiedViewController.h"
#import <Accelerate/Accelerate.h>
#import <CoreMotion/CoreMotion.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface myHealthViewController ()

@property (nonatomic, strong) CMStepCounter *stepCounter;

@property (nonatomic,strong)UILabel *healthLabel;

@property (nonatomic, strong) CMPedometer *pedometer;

@end

@implementation myHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的健康";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhui.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(ret)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"xiugai.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(modified)];
    [self loadData];
}

- (void)loadData{
    self.healthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, 0.65*kScreenHeight, 0.7*kScreenWidth, 30)];
    self.healthLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.healthLabel];
    
    if ([CMStepCounter isStepCountingAvailable]) {
        self.stepCounter = [[CMStepCounter alloc]init];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [self.stepCounter startStepCountingUpdatesToQueue:queue updateOn:5 withHandler:^(NSInteger numberOfSteps, NSDate * _Nonnull timestamp, NSError * _Nullable error) {
            self.healthLabel.text = [NSString stringWithFormat:@"用户已经走了%ld步",(long)numberOfSteps];
        }];
    }
    if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [[CMPedometer alloc]init];
        [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            CMPedometerData *data = (CMPedometerData *)pedometerData;
            NSNumber *number = data.numberOfSteps;
            self.healthLabel.text = [NSString stringWithFormat:@"用户已经走了%@步",number];
        }];
    }
}

- (void)ret{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modified{
    ModifiedViewController *modified = [[ModifiedViewController alloc]init];
    [self.navigationController pushViewController:modified animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
