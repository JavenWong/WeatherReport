//
//  NowModel.h
//  WeatherReport
//
//  Created by JavenWong on 16/2/26.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowModel : NSObject

@property (strong, nonatomic) NSDictionary *cond; // 天气情况 key =txt
@property (strong, nonatomic) NSString *fl; // 体感温度
@property (strong, nonatomic) NSString *hum; // 相对湿度
@property (strong, nonatomic) NSString *pcpn; // 降水量
@property (strong, nonatomic) NSString *pres; // 气压
@property (strong, nonatomic) NSString *tmp; // 温度
@property (strong, nonatomic) NSString *vis; // 能见度
@property (strong, nonatomic) NSDictionary *wind; // 风力 /*"dir": "北风", 风向"sc": "3级"风力"spd": "15" 风速（kmph）*/



@end
