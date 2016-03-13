//
//  judgeWeatherSituation.m
//  weather
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 Corporal. All rights reserved.
//

#import "judgeWeatherSituation.h"
#import "APIStoreSDK.h"
#import "DailyForecastModel.h"

@implementation judgeWeatherSituation

+ (UIImage *)setTodayWithTomorrowImage:(NSString *)situation
{
    if ([situation isEqualToString:@"晴"]) {
        return [UIImage imageNamed:@"sunny.png"];
    }
    else if ([situation isEqualToString:@"阴"])
    {
        return [UIImage imageNamed:@"overcast.png"];
    }
    else if ([situation isEqualToString:@"晴间多云"] || [situation isEqualToString:@"多云"])
    {
        return [UIImage imageNamed:@"cloudy.png"];
        
    }
 
    else if ([situation containsString:@"雨"])
    {
        return [UIImage imageNamed:@"rainy.png"];
        
    }
    else if ([situation containsString:@"雪"])
    {
        return [UIImage imageNamed:@"ice.png"];
    }
    
    else
    {
        return [UIImage imageNamed:@"cloudy.png"];
        
    }
    
}

- (void)getTmpForCityVC
{
    NSMutableArray *cityNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
    for (int i = 0; i < cityNameArr.count; i++) {
        [self loadData:cityNameArr[i]];
    }
    
}

- (void)loadData:(NSString *)cityName
{
    NSString *keyName = @"5b3c230b6b40fcb10287e9e29184bc6f";
    
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        if(responseString != nil) {
            
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            [self dealWithModel:dic cityName:cityName];
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
    };
    
    //部分参数
    NSString *uri = @"http://apis.baidu.com/heweather/weather/free";
    NSString *method = @"post";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:cityName forKey:@"city"];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:keyName parameter:parameter callBack:callBack];
}



- (void)dealWithModel:(NSDictionary *)dic cityName:(NSString *)cityName
{
    NSArray *arr = dic[@"HeWeather data service 3.0"];
    
    
    
    for (NSDictionary *dic2 in arr) {
        
        DailyForecastModel *dailyModel = [[DailyForecastModel alloc] init];
        NSDictionary *dic3 = dic2[@"daily_forecast"][0];
        dailyModel.tmp = dic3[@"tmp"];
        NSString *maxTmp = dailyModel.tmp[@"max"];
        [[NSUserDefaults standardUserDefaults] setObject:maxTmp forKey:[NSString stringWithFormat:@"%@TmpMax", cityName]];
        NSString *minTmp = dailyModel.tmp[@"min"];
        
        [[NSUserDefaults standardUserDefaults] setObject:minTmp forKey:[NSString stringWithFormat:@"%@TmpMin", cityName]];
    }
}

@end
