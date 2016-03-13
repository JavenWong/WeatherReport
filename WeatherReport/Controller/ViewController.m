//
//  ViewController.m
//  WeatherReport
//
//  Created by JavenWong on 16/2/26.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "ViewController.h"
#import "NowModel.h"
#import "CityTableViewController.h"
#import "APIStoreSDK.h"
#import "DailyForecastModel.h"
#import "judgeWeatherSituation.h"
#import "AddCityViewController.h"
#import "DrawLineView.h"
#import "MBProgressHUD.h"



@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *cond_txtLb;
@property (strong, nonatomic) UILabel *tmpLb;
@property (strong, nonatomic) NowModel *nowModel;



@property (strong, nonatomic) UILabel *scLabel; // 风力数据
@property (strong, nonatomic) UILabel *humLabel; // 湿度数据
@property (strong, nonatomic) UILabel *SCLabel;
@property (strong, nonatomic) UILabel *HUMlabel;
@property (nonatomic, assign) BOOL changeBool;

@property (nonatomic, strong) DailyForecastModel *todayForecastModel;
@property (nonatomic, strong) DailyForecastModel *tomorrowForecastModel;
@property (strong, nonatomic) UILabel *todayTempertureLb;
@property (nonatomic, strong) NSArray *daily_forecastDic;
@property (strong, nonatomic) UILabel *WeatherOfTodayLb;

@property (strong, nonatomic) UILabel *tomorrowTempertureLb;
@property (strong, nonatomic) UILabel *WeatherOfTomorrowLb;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *todayWeatherImage;
@property (strong, nonatomic) UIImageView *tomorrowWeatherImage;

@property (strong, nonatomic) UIImageView *imageView; // loading数据时候弹出的画面, 不至于loading的时候那么难看

@property (strong, nonatomic) NSMutableArray *maxTmpSevenDay;
@property (strong, nonatomic) NSMutableArray *minTmpSevenDay;
//@property (strong, nonatomic) UIView *scrollView;

@property (strong, nonatomic) DrawLineView *lineView;
@property (strong, nonatomic) UIView *todayView;
@property (strong, nonatomic) UIView *tomorrowView;
@property (strong, nonatomic) UIScrollView *scrollViewTure;
@end

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@implementation ViewController


- (void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]) {
        // it is more beautiful when data loading
        if (self.dataDic == nil) {
            self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
            self.imageView.image = [UIImage imageNamed:@"fog.jpg"];
            [self.view addSubview:self.imageView];
        }
        
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
        self.navigationItem.title = cityName;

        [self loadData:cityName];
        
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"]) {
            NSMutableArray *cityNameArr = [NSMutableArray array];
            [[NSUserDefaults standardUserDefaults] setObject:cityNameArr forKey:@"cityNameArr"];
        }
        
        judgeWeatherSituation *model = [[judgeWeatherSituation alloc] init];
        [model getTmpForCityVC];
    }
    else {
        AddCityViewController *vc = [[AddCityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self loadUI];
    
    
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];

    self.navigationItem.title = cityName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_edit@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(turnToCityPage:)];
    self.todayView.frame = CGRectMake(0, self.view.bounds.size.height - self.todayView.frame.size.height, self.todayView.frame.size.width, self.todayView.frame.size.height);
    self.tomorrowView.frame = CGRectMake(self.tomorrowView.frame.origin.x, self.view.bounds.size.height - self.todayView.frame.size.height, self.todayView.frame.size.width, self.todayView.frame.size.height);
}

#pragma mark - private methods
- (void)loadData:(NSString *)cityName2;
{
    NSString *cityName = cityName2;
    NSString *keyName = @"5b3c230b6b40fcb10287e9e29184bc6f";
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        if(responseString != nil) {
            
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
//            NSLog(@"%@", dic);
            
            self.dataDic = dic;
            
            
            
        
            [self DealWithNewModel:dic];
            [self setBackgroundImageByWeather];
            
            
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
        [self.imageView removeFromSuperview];
    };
    
    //部分参数
    NSString *uri = @"http://apis.baidu.com/heweather/weather/free";
    NSString *method = @"post";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:cityName forKey:@"city"];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:keyName parameter:parameter callBack:callBack];
}


- (void)DealWithNewModel:(NSDictionary *)dic
{
    // 是否动画
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] == nil) {
        NSString *didCloseAnimation = @"1";
        [[NSUserDefaults standardUserDefaults] setObject:didCloseAnimation forKey:@"didCloseAnimation"];
    }
    self.condView = [[SetBackgroundImageByCond alloc] initWithFrame:self.view.frame];
    self.condView.flag = NO;
    [self.view addSubview:self.condView];
    [self.view sendSubviewToBack:self.condView];
    
    self.navigationController.navigationBarHidden = NO;
    UIImage *emptyImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:emptyImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = emptyImage;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    NSArray *arr = dic[@"HeWeather data service 3.0"];
    if ([arr[0][@"status"] isEqualToString:@"unknown city"]) {
        CityTableViewController *vc = [[CityTableViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:NO];
        NSString *cityName22 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
        NSMutableArray *cityNameArr22 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
        NSMutableArray *arr22 = [NSMutableArray arrayWithArray:cityNameArr22];
        [arr22 removeObject:cityName22];
        [[NSUserDefaults standardUserDefaults] setObject:arr22 forKey:@"cityNameArr"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无此城市信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
    
    
    
    for (NSDictionary *dic2 in arr) {
        self.nowModel = [[NowModel alloc] init];
        [self.nowModel setValuesForKeysWithDictionary:dic2[@"now"]];
        
        self.daily_forecastDic = dic2[@"daily_forecast"];
        
    }
    
    if (self.timer == nil) {
        // 用来做折线图的最高温度和最低温度
        self.maxTmpSevenDay = [NSMutableArray array];
        self.minTmpSevenDay = [NSMutableArray array];
        
        for (int i = 0; i < self.daily_forecastDic.count; i++) {
            NSDictionary *dic1 = self.daily_forecastDic[i];
            NSDictionary *dic2 = dic1[@"tmp"];
            
            NSString *maxTmp = dic2[@"max"];
            NSString *minTmp = dic2[@"min"];
            [self.maxTmpSevenDay addObject:maxTmp];
            [self.minTmpSevenDay addObject:minTmp];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.maxTmpSevenDay forKey:@"maxTmpSevenDay"];
        [[NSUserDefaults standardUserDefaults] setObject:self.minTmpSevenDay forKey:@"minTmpSevenDay"];
        self.lineView = [[DrawLineView alloc] initWithFrame:CGRectMake(0, kHeight + 20, kWidth, kHeight - 49 - 64 - 150)];
        self.lineView.backgroundColor = [UIColor clearColor];
        self.lineView.center = CGPointMake(self.view.center.x, self.lineView.center.y);
        [self.scrollViewTure addSubview:self.lineView];
        self.lineView.dic = self.dataDic;
        
        // 切换展示的信息
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeWind) userInfo:nil repeats:YES];
        
        [self.timer fire];
    }
    
    self.scrollViewTure.delegate = self;
    MBProgressHUD *hud = [self.view viewWithTag:100];
    [hud hide:YES afterDelay:1];
    
    
    self.cond_txtLb.text = self.nowModel.cond[@"txt"];
    self.tmpLb.text = [NSString stringWithFormat:@"%@°C", self.nowModel.tmp];
    self.SCLabel.text = @"风力";
    self.HUMlabel.text = @"湿度";
    self.scLabel.text =  [NSString stringWithFormat:@"风力:%@级", self.nowModel.wind[@"sc"]];
    self.humLabel.text = [NSString stringWithFormat:@"湿度:%@%%", self.nowModel.hum];
    
    
    self.todayForecastModel = [[DailyForecastModel alloc]init];
    
    self.tomorrowForecastModel = [[DailyForecastModel alloc]init];
    [self showWeatherOfTodaywithTomorrow];
}

- (void)showWeatherOfTodaywithTomorrow  // 底部界面, 包括今天和明天的天气情况
{
    // 今天天气状况
    [self.todayForecastModel setValuesForKeysWithDictionary:self.daily_forecastDic[0]];
    [self determindeCurrentTime:self.todayForecastModel WeatherOfTodayLb:self.WeatherOfTodayLb];
    self.todayTempertureLb.text = [NSString stringWithFormat:@"%@°C / %@°C", self.todayForecastModel.tmp[@"max"] , self.todayForecastModel.tmp[@"min"]];
    
    
    // 明天天气状况
    [self.tomorrowForecastModel setValuesForKeysWithDictionary:self.daily_forecastDic[1]];
    self.tomorrowTempertureLb.text = [NSString stringWithFormat:@"%@°C / %@°C", self.tomorrowForecastModel.tmp[@"max"] , self.tomorrowForecastModel.tmp[@"min"]];
    [self determindeCurrentTime:self.tomorrowForecastModel WeatherOfTodayLb:self.WeatherOfTomorrowLb];
    
    [self setTodayWithTomorrowImage];
    
}


// 判断当前是白天还是晚上
- (void)determindeCurrentTime:(DailyForecastModel *)ForecastModel WeatherOfTodayLb:(UILabel *)weatherLb
{
    NSString *txt_n1 = ForecastModel.cond[@"txt_d"]; // 今天夜间天气状况描述
    NSString *txt_d1 = ForecastModel.cond[@"txt_n"]; // 今天白天天气状况描述
    
    // 获得日出日落时间
    NSString *dayStr = ForecastModel.astro[@"sr"];
    NSString *nightStr = ForecastModel.astro[@"ss"];
    NSArray *array = [dayStr componentsSeparatedByString:@":"];
    int hour1 = [array[0] intValue];
    int minute1 = [array[1] intValue];
    
    NSArray *array1 = [nightStr componentsSeparatedByString:@":"];
    int hour2 = [array1[0] intValue];
    int minute2 = [array1[1] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *currentStr = [dateStr substringWithRange:NSMakeRange(11, 5)];
    NSArray *array2 = [currentStr componentsSeparatedByString:@":"];
    int hour3 = [array2[0] intValue];
    int minute3 = [array2[1] intValue];
    if (hour3 * 60 + minute3 > hour1 * 60 + minute1 && hour3 * 60 + minute3 < hour2 * 60 + minute2) {
        weatherLb.text = [NSString stringWithFormat:@"%@", txt_d1];
    }
    else
    {
        weatherLb.text = [NSString stringWithFormat:@"%@", txt_n1];
    }
    
}

// 下面的两个天气小图片
-  (void)setTodayWithTomorrowImage
{
    
    self.todayWeatherImage.image = [judgeWeatherSituation setTodayWithTomorrowImage:self.WeatherOfTodayLb.text];
    self.tomorrowWeatherImage.image = [judgeWeatherSituation setTodayWithTomorrowImage:self.WeatherOfTomorrowLb.text];
    
}

- (void)changeWind
{
    
    if (self.changeBool) {
        self.SCLabel.text = @"风力";
        self.HUMlabel.text = @"湿度";
        self.scLabel.text =  [NSString stringWithFormat:@"风力: %@级", self.nowModel.wind[@"sc"]];
        self.humLabel.text = [NSString stringWithFormat:@"湿度: %@%%", self.nowModel.hum];
        self.changeBool = !self.changeBool;
    }
    
    else
    {
        self.SCLabel.text = @"风向";
        self.HUMlabel.text = @"气压";
        self.scLabel.text =  [NSString stringWithFormat:@"风向: %@", self.nowModel.wind[@"dir"]];
        NSDictionary *dic4 = self.daily_forecastDic[0];
        self.humLabel.text = [NSString stringWithFormat:@"气压: %@", dic4[@"pres"]];
        self.changeBool = !self.changeBool;
    }
    
}

// 根据天气设置背景图片
- (void)setBackgroundImageByWeather
{
    [self.condView SetBackgroundImageByCond:self.nowModel.cond[@"txt"]];
}

// 跳转city页面设置
- (void)turnToCityPage:(UIBarButtonItem *)barButtonItem
{
    
    
    CityTableViewController *cityVC = [[CityTableViewController alloc] init];
//    cityVC.changeCityNameBlock = ^(NSString *cityName) {
//        self.navigationItem.title = cityName;
//        [self loadData:cityName];
//    };
    [self.navigationController pushViewController:cityVC animated:YES];
    UIImageView *imageview = self.condView.subviews[0];
    cityVC.backgroundImage = imageview.image;
//    cityVC.dataDic = self.dataDic;
    
}

#pragma mark - scrollView delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView.contentOffset.y < -60) {
//        [self loadData:self.navigationItem.title];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"正在刷新数据";
//        hud.tag = 100;
//        [self.view addSubview:hud];
//    }
//}

#pragma mark - UI
- (void)loadUI {
    self.scrollViewTure = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.scrollViewTure.contentSize = CGSizeMake(kWidth, self.scrollViewTure.frame.size.height * 2 - 64-64-49);
    [self.view addSubview:self.scrollViewTure];
    UIView *zuoxia = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 120 - 49 - 64, kWidth / 2, 120)];
    [self.scrollViewTure addSubview:zuoxia];
    UIView *youxia = [[UIView alloc] initWithFrame:CGRectMake(kWidth / 2, kHeight - 120 - 49 - 64, kWidth / 2, 120)];
    [self.scrollViewTure addSubview:youxia];
    UIView *zuoshang = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 120 - 130 - 49 - 64, kWidth, 130)];
    [self.scrollViewTure addSubview:zuoshang];
    
    self.cond_txtLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 21)];
    self.cond_txtLb.textColor = [UIColor whiteColor];
    [zuoshang addSubview:self.cond_txtLb];
    self.tmpLb = [[UILabel alloc] initWithFrame:CGRectMake(20, self.cond_txtLb.frame.origin.y + 21, 300, 54)];
    self.tmpLb.textColor = [UIColor whiteColor];
    self.tmpLb.font = [UIFont systemFontOfSize:45];
    [zuoshang addSubview:self.tmpLb];
    self.scLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tmpLb.frame) + 10, 110, 21)];
    self.scLabel.textColor = [UIColor whiteColor];
    [zuoshang addSubview:self.scLabel];
    self.humLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scLabel.frame) + 10, self.scLabel.frame.origin.y, 110, 21)];
    self.humLabel.textColor = [UIColor whiteColor];
    [zuoshang addSubview:self.humLabel];
//    self.SCLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tmpLb.frame) + 10, 80, 21)];
//    [zuoshang addSubview:self.SCLabel];
//    self.HUMlabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scLabel.frame), self.scLabel.frame.origin.y, 80, 21)];
    [zuoshang addSubview:self.HUMlabel];
    
    self.todayTempertureLb = [[UILabel alloc] initWithFrame:CGRectMake(zuoxia.frame.size.width - 100, 20, 100, 21)];
    self.todayTempertureLb.textColor = [UIColor whiteColor];
    [zuoxia addSubview:self.todayTempertureLb];
    self.WeatherOfTodayLb = [[UILabel alloc] initWithFrame:CGRectMake(20, zuoxia.frame.size.height - 20 - 21, 100, 21)];
    self.WeatherOfTodayLb.textColor = [UIColor whiteColor];
    [zuoxia addSubview:self.WeatherOfTodayLb];
    self.todayWeatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(zuoxia.frame.size.width - 60, zuoxia.frame.size.height - 55, 40, 40)];
    [zuoxia addSubview:self.todayWeatherImage];
    UILabel *zuoxiaLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 21)];
    zuoxiaLb.text = @"今天";
    zuoxiaLb.textColor = [UIColor whiteColor];
    [zuoxia addSubview:zuoxiaLb];
    
    self.tomorrowTempertureLb = [[UILabel alloc] initWithFrame:CGRectMake(youxia.frame.size.width - 100, 20, 100, 21)];
    self.tomorrowTempertureLb.textColor = [UIColor whiteColor];
    [youxia addSubview:self.tomorrowTempertureLb];
    self.WeatherOfTomorrowLb = [[UILabel alloc] initWithFrame:CGRectMake(20, youxia.frame.size.height - 20 - 21, 100, 21)];
    self.WeatherOfTomorrowLb.textColor = [UIColor whiteColor];
    [youxia addSubview:self.WeatherOfTomorrowLb];
    self.tomorrowWeatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(youxia.frame.size.width - 60, youxia.frame.size.height - 55, 40, 40)];
    [youxia addSubview:self.tomorrowWeatherImage];
    UILabel *youxiaLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 21)];
    youxiaLb.text = @"明天";
    youxiaLb.textColor = [UIColor whiteColor];
    [youxia addSubview:youxiaLb];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    [self.lineView removeFromSuperview];
    self.lineView = nil;
    self.condView.flag = YES;
    [self.condView removeFromSuperview];
    self.condView = nil;
    NSLog(@"%@", self.condView);
    NSLog(@"%@", self.timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
