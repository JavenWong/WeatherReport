//
//  DailyForecastModel.h
//  weather
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 Corporal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyForecastModel : NSObject

@property (strong, nonatomic) NSString *date;
@property (nonatomic, strong) NSDictionary *astro; // 记录日出和日落时间
@property (nonatomic, strong) NSDictionary *cond; // 天气变换情况
@property (strong, nonatomic) NSString *hum;
@property (strong, nonatomic) NSString *pcpn;
@property (strong, nonatomic) NSString *pop;
@property (strong, nonatomic) NSString *pres;
@property (nonatomic, strong) NSDictionary *tmp; // 最高温度, 最低温度 max min
@property (strong, nonatomic) NSString *vis;
@property (strong, nonatomic) NSDictionary *wind;

@end
