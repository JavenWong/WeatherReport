//
//  judgeWeatherSituation.h
//  weather
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 Corporal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface judgeWeatherSituation : NSObject


+ (UIImage *)setTodayWithTomorrowImage:(NSString *)situation;

//+ (UIImage *)setBackgroundImageByWeather:(NSString *)situation;
- (void)getTmpForCityVC;

@end
