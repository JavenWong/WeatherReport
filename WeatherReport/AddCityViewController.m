//
//  AddCityViewController.m
//  WeatherReport
//
//  Created by JavenWong on 16/2/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "AddCityViewController.h"
#import "ViewController.h"

@interface AddCityViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nanjingBtn;
@property (weak, nonatomic) IBOutlet UIButton *shenzhenBtn;
@property (weak, nonatomic) IBOutlet UIButton *guangzhouBtn;
@property (weak, nonatomic) IBOutlet UIButton *changshaBtn;
@property (weak, nonatomic) IBOutlet UIButton *wuhanBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhengzhouBtn;
@property (weak, nonatomic) IBOutlet UIButton *haerbinBtn;
@property (weak, nonatomic) IBOutlet UIButton *changchunBtn;
@property (weak, nonatomic) IBOutlet UIButton *dalianBtn;
@property (weak, nonatomic) IBOutlet UIButton *shenyangBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongqingBtn;
@property (weak, nonatomic) IBOutlet UIButton *shanghaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *beijingBtn;
@property (weak, nonatomic) IBOutlet UIButton *tianjinBtn;
@property (strong, nonatomic) NSArray *cityBtnArr;

@end

@implementation AddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.cityBtnArr = @[_nanjingBtn,_shenzhenBtn,_guangzhouBtn,_changshaBtn,_wuhanBtn,_zhengzhouBtn,_haerbinBtn,_changchunBtn,_dalianBtn,_shenyangBtn,_chongqingBtn,_shanghaiBtn,_beijingBtn,_tianjinBtn];
    for (UIButton *btn in self.cityBtnArr) {
        [btn addTarget:self action:@selector(turnToCityVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)turnToCityVC:(UIButton *)button
{
    NSString *cityName = button.titleLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"cityName"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSMutableArray *cityNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
    if ([cityNameArr containsObject:cityName]) {
        
    }
    else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:cityNameArr];
        [arr addObject:cityName];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"cityNameArr"];
    }
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
