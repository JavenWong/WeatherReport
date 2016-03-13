//
//  DrawLineView.m
//  WeatherReport
//
//  Created by JavenWong on 16/3/1.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "DrawLineView.h"
#import "DailyForecastModel.h"
#import "judgeWeatherSituation.h"

@interface DrawLineView ()
@property (strong, nonatomic) NSMutableArray *modelArr;
@end

@implementation DrawLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawLines];

}

// 找到数组中最大的那个
- (NSInteger)GetMaxFromArr:(NSMutableArray *)arr
{
    NSInteger max = [arr[0] integerValue];
    for (int i = 0; i < arr.count; i++) {
        NSInteger max1 = [arr[i] integerValue];
        max = max > max1 ? max : max1;
    }
    return max;
}

- (NSInteger)GetMinFromArr:(NSMutableArray *)arr
{
    NSInteger min = [arr[0] integerValue];
    for (int i = 0; i < arr.count; i++) {
        NSInteger min1 = [arr[i] integerValue];
        min = min < min1 ? min : min1;
    }
    return min;
}

- (void)drawLines
{
    [self loadData];
    
    NSMutableArray *maxArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxTmpSevenDay"];
    NSInteger max = [self GetMaxFromArr:maxArr];
    NSMutableArray *minArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"minTmpSevenDay"];
    NSInteger min = [self GetMinFromArr:minArr];
    float time = (self.frame.size.height - 8) / (max - min);
    for (int i = 0; i < maxArr.count - 1; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, self.frame.size.width / 8 * (i + 1), (max - [maxArr[i] integerValue]) * time + 4);
        CGContextAddLineToPoint(context, self.frame.size.width / 8 * (i + 2), (max - [maxArr[i + 1] integerValue]) * time + 4);
        CGContextStrokePath(context);
        
    }
    // point
    for (int i = 0; i < maxArr.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, self.frame.size.width / 8 * (i + 1), (max - [maxArr[i] integerValue]) * time + 4, 3, 0, 2 * M_PI, 1);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextFillPath(context);
        
    }
    for (int i = 0; i < minArr.count - 1; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, self.frame.size.width / 8 * (i + 1), (max - [minArr[i] integerValue]) * time - 4);
        CGContextAddLineToPoint(context, self.frame.size.width / 8 * (i + 2), (max - [minArr[i + 1] integerValue]) * time - 4);
        CGContextStrokePath(context);
    }
    for (int i = 0; i < minArr.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, self.frame.size.width / 8 * (i + 1), (max - [minArr[i] integerValue]) * time - 4, 3, 0, 2 * M_PI, 1);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextFillPath(context);
    }
    // UI
    for (int i = 0; i < maxArr.count; i++) {
        // 下面的UI
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 8 * (i + 1) - 30, (max - [minArr[i] integerValue]) * time + 5, 60, 25)];
        label.text = minArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame) + 15, self.frame.size.height + 16, 30, 30)];
        
        [self addSubview:imageView];
        
        UILabel *condLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(imageView.frame), 60, 25)];
        DailyForecastModel *model = self.modelArr[i];
        NSString *cond_txt_n = model.cond[@"txt_n"];
        condLb.text = cond_txt_n;
        condLb.textAlignment = NSTextAlignmentCenter;
        condLb.font = [UIFont systemFontOfSize:14];
        condLb.textColor = [UIColor whiteColor];
        imageView.image = [judgeWeatherSituation setTodayWithTomorrowImage:condLb.text];
        [self addSubview:condLb];
        
        // 上面的UI
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 8 * (i + 1) - 30, (max - [maxArr[i] integerValue]) * time - 25, 60, 25)];
        label2.text = maxArr[i];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor whiteColor];

        [self addSubview:label2];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label2.frame) + 15, - 48, 30, 30)];
        imageView2.image = [UIImage imageNamed:@"ice"];
        [self addSubview:imageView2];
        
        UILabel *condLb2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label2.frame), CGRectGetMinY(imageView2.frame) - imageView2.frame.size.height + 10, 60, 22)];
        NSString *cond_txt_d = model.cond[@"txt_d"];
        condLb2.text = cond_txt_d;
        condLb2.font = [UIFont systemFontOfSize:14];
        condLb2.textAlignment = NSTextAlignmentCenter;
        condLb2.textColor = [UIColor whiteColor];
        imageView2.image = [judgeWeatherSituation setTodayWithTomorrowImage:condLb2.text];
        [self addSubview:condLb2];
        
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label2.frame), CGRectGetMinY(condLb2.frame) - 22, 60, 22)];
        
        NSString *date = [model.date substringFromIndex:5];
        dateLb.text = date;
        dateLb.font = [UIFont systemFontOfSize:12];
        dateLb.textColor = [UIColor whiteColor];
        dateLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLb];
    }
}

- (void)loadData
{
    self.modelArr = [NSMutableArray array];
    NSArray *arr = self.dic[@"HeWeather data service 3.0"];
    NSArray *dailyArr = [NSArray array];
    for (NSDictionary *dic2 in arr) {
        dailyArr = dic2[@"daily_forecast"];
    }
    for (int i = 0; i < dailyArr.count; i++) {
        DailyForecastModel *model = [[DailyForecastModel alloc] init];
        [model setValuesForKeysWithDictionary:dailyArr[i]];
        [self.modelArr addObject:model];
    }
}

@end
