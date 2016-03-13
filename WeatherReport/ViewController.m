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
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cond_txtLb;
@property (weak, nonatomic) IBOutlet UILabel *tmpLb;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) NowModel *nowModel;



@property (weak, nonatomic) IBOutlet UILabel *scLabel; // 风力数据
@property (weak, nonatomic) IBOutlet UILabel *humLabel; // 湿度数据
@property (weak, nonatomic) IBOutlet UILabel *SCLabel;
@property (weak, nonatomic) IBOutlet UILabel *HUMlabel;
@property (nonatomic, assign) BOOL changeBool;

@property (nonatomic, strong) DailyForecastModel *todayForecastModel;
@property (nonatomic, strong) DailyForecastModel *tomorrowForecastModel;
@property (weak, nonatomic) IBOutlet UILabel *todayTempertureLb;
@property (nonatomic, strong) NSArray *daily_forecastDic;
@property (weak, nonatomic) IBOutlet UILabel *WeatherOfTodayLb;

@property (weak, nonatomic) IBOutlet UILabel *tomorrowTempertureLb;
@property (weak, nonatomic) IBOutlet UILabel *WeatherOfTomorrowLb;

@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *todayWeatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *tomorrowWeatherImage;

@property (strong, nonatomic) UIImageView *imageView; // loading数据时候弹出的画面, 不至于loading的时候那么难看

@property (strong, nonatomic) NSMutableArray *maxTmpSevenDay;
@property (strong, nonatomic) NSMutableArray *minTmpSevenDay;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@property (strong, nonatomic) DrawLineView *lineView;
@end

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
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];

    self.navigationItem.title = cityName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_edit@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(turnToCityPage:)];
    
    
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
            
            NSLog(@"%@", dic);
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
    NSArray *arr = dic[@"HeWeather data service 3.0"];
    
    
    
    for (NSDictionary *dic2 in arr) {
        self.nowModel = [[NowModel alloc] init];
        [self.nowModel setValuesForKeysWithDictionary:dic2[@"now"]];
        
        self.daily_forecastDic = dic2[@"daily_forecast"];
        
    }
    
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
    self.lineView = [[DrawLineView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height + 50, self.view.bounds.size.width, 250)];
    self.lineView.backgroundColor = [UIColor clearColor];
    self.lineView.center = CGPointMake(self.view.center.x, self.lineView.center.y);
    [self.scrollView addSubview:self.lineView];
    self.lineView.dic = self.dataDic;
    
    
    
    self.cond_txtLb.text = self.nowModel.cond[@"txt"];
    self.tmpLb.text = [NSString stringWithFormat:@"%@°C", self.nowModel.tmp];
    self.SCLabel.text = @"风力";
    self.HUMlabel.text = @"湿度";
    self.scLabel.text =  [NSString stringWithFormat:@"%@级", self.nowModel.wind[@"sc"]];
    self.humLabel.text = [NSString stringWithFormat:@"%@%%", self.nowModel.hum];
    
    // 切换展示的信息
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeWind) userInfo:nil repeats:YES];
    
    [self.timer fire];
    self.todayForecastModel = [[DailyForecastModel alloc]init];
    
    self.tomorrowForecastModel = [[DailyForecastModel alloc]init];
    [self showWeatherOfTodaywithTomorrow];
}

- (void)showWeatherOfTodaywithTomorrow  // 底部界面, 包括今天和明天的天气情况
{
    // 今天天气状况
    [self.todayForecastModel setValuesForKeysWithDictionary:self.daily_forecastDic[0]];
    [self determindeCurrentTime:self.todayForecastModel WeatherOfTodayLb:self.WeatherOfTodayLb];
    self.todayTempertureLb.text = [NSString stringWithFormat:@"%@°C /%@°C", self.todayForecastModel.tmp[@"max"] , self.todayForecastModel.tmp[@"min"]];
    
    
    // 明天天气状况
    [self.tomorrowForecastModel setValuesForKeysWithDictionary:self.daily_forecastDic[1]];
    self.tomorrowTempertureLb.text = [NSString stringWithFormat:@"%@°C /%@°C", self.tomorrowForecastModel.tmp[@"max"] , self.tomorrowForecastModel.tmp[@"min"]];
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
        self.scLabel.text =  [NSString stringWithFormat:@"%@级", self.nowModel.wind[@"sc"]];
        self.humLabel.text = [NSString stringWithFormat:@"%@%%", self.nowModel.hum];
        self.changeBool = !self.changeBool;
    }
    
    else
    {
        self.SCLabel.text = @"风向";
        self.HUMlabel.text = @"气压";
        self.scLabel.text =  [NSString stringWithFormat:@"%@", self.nowModel.wind[@"dir"]];
        self.humLabel.text = self.nowModel.pres;
        self.changeBool = !self.changeBool;
    }
    
}

// 根据天气设置背景图片
- (void)setBackgroundImageByWeather
{
    if ([self.nowModel.cond[@"txt"] isEqualToString:@"晴"]) {
        self.backgroundImageView.image = [UIImage imageNamed:@"sunny.jpg"];
    }
    else if ([self.nowModel.cond[@"txt"] isEqualToString:@"多云"]) {
        self.backgroundImageView.image = [UIImage imageNamed:@"cloudy.jpg"];
    }
    else if ([self.nowModel.cond[@"txt"] isEqualToString:@"霾"])
    {
       self.backgroundImageView.image = [UIImage imageNamed:@"fog.jpg"]; 
        
    }
}

// 跳转city页面设置
- (void)turnToCityPage:(UIBarButtonItem *)barButtonItem
{
    [self.timer invalidate];
    self.timer = nil;
   // [self.lineView removeFromSuperview];
    CityTableViewController *cityVC = [[CityTableViewController alloc] init];
    cityVC.changeCityNameBlock = ^(NSString *cityName) {
        self.navigationItem.title = cityName;
        [self loadData:cityName];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
    cityVC.dataDic = self.dataDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
