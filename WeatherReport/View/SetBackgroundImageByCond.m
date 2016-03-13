//
//  SetBackgroundImageByCond.m
//  SetBackgroundImageByCond
//
//  Created by JavenWong on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "SetBackgroundImageByCond.h"

#define kHeight self.bounds.size.height
#define kWidth self.bounds.size.width

@interface SetBackgroundImageByCond ()

@property (strong, nonatomic) UIImageView *cloudy_day_cloud4;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud4_2;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud3;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud3_2;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud2;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud2_2;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud1;
@property (strong, nonatomic) UIImageView *cloudy_day_cloud1_2;

@end


@implementation SetBackgroundImageByCond

- (void)dealloc
{
    NSLog(@"%@", self);
}

- (void)SetBackgroundImageByCond:(NSString *)cond
{
    if ([cond isEqualToString:@"多云"]) {
        [self cloudy];
    } else if ([cond isEqualToString:@"晴"]) {
        [self sunny];
    } else if ([cond isEqualToString:@"阴"]) {
        [self overcast];
    } else if ([cond containsString:@"雨"]) {
        [self raining];
    }
}

#pragma mark - raining
- (void)raining {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_middle_rain" ofType:@"jpg"]];
    [self addSubview:backgroundView];
    
    UIImage *ele_middleRainCloud1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_middleRainCloud1" ofType:@"png"]];
    UIImage *ele_middleRainCloud2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_middleRainCloud2" ofType:@"png"]];
    UIImage *ele_middleRainCloud3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_middleRainCloud3" ofType:@"png"]];
    UIImage *ele_rainLine1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_rainLine1" ofType:@"png"]];
    UIImage *ele_rainLine2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_rainLine2" ofType:@"png"]];
    UIImage *ele_rainLine3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_rainLine3" ofType:@"png"]];
    
    CGFloat cloud3width = ele_middleRainCloud3.size.width / ele_middleRainCloud3.size.height * (kHeight / 2);
    
    UIImageView *ele_middleRainCloud3View = [[UIImageView alloc] initWithFrame:CGRectMake(-(cloud3width - kWidth), 0, cloud3width, kHeight / 2)];
    UIImageView *ele_middleRainCloud3View_2 = [[UIImageView alloc] initWithFrame:CGRectMake(-(2 * cloud3width - kWidth), 0, cloud3width, kHeight / 2)];
    UIImageView *ele_middleRainCloud1View = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, ele_middleRainCloud1.size.width, ele_middleRainCloud1.size.height)];
    UIImageView *ele_middleRainCloud2View = [[UIImageView alloc] initWithFrame:CGRectMake(50, -10, ele_middleRainCloud2.size.width, ele_middleRainCloud2.size.height)];
    
    ele_middleRainCloud3View.image = ele_middleRainCloud3;
    ele_middleRainCloud3View_2.image = ele_middleRainCloud3;
    ele_middleRainCloud2View.image = ele_middleRainCloud2;
    ele_middleRainCloud1View.image = ele_middleRainCloud1;


    [self addSubview:ele_middleRainCloud3View];
    [self addSubview:ele_middleRainCloud3View_2];
    [self addSubview:ele_middleRainCloud2View];
    [self addSubview:ele_middleRainCloud1View];
    
    NSString *didCloseAnimation = [[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"];
    if ([didCloseAnimation isEqualToString:@"1"]) {
        [self rainingCloudMove3:ele_middleRainCloud3View image:ele_middleRainCloud3];
        [self rainingCloudMove3_2:ele_middleRainCloud3View_2 image:ele_middleRainCloud3];
        [self rainingCloudMove2:8 imageView:ele_middleRainCloud2View image:ele_middleRainCloud2];
        [self rainingCloudMove2:10 imageView:ele_middleRainCloud1View image:ele_middleRainCloud1];
        for (int i = 0; i < 8; i++) {
            [self rainingDrops:1 image:ele_rainLine1 delay:0.66];
            [self rainingDrops:1 image:ele_rainLine2 delay:0.33];
            [self rainingDrops:1 image:ele_rainLine3 delay:0];
        }
    }
    
}

- (void)rainingDrops:(CGFloat)duration image:(UIImage *)image delay:(CGFloat)delay {
    double x = arc4random() % ((int)kWidth - 0 + 1);
    double y = arc4random() % (200 - 0 + 1);
    UIImageView *rainingView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, image.size.width / 2, image.size.height / 2)];
    rainingView.image = image;
    rainingView.alpha = 0.8;
    [self addSubview:rainingView];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        rainingView.frame = CGRectMake(x + 120, kHeight, image.size.width / 2, image.size.height / 2);
    } completion:^(BOOL finished) {
        [rainingView removeFromSuperview];
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self rainingDrops:duration image:image delay:0];
        }
    }];

}

- (void)rainingCloudMove2:(CGFloat)duration imageView:(UIImageView *)imageView image:(UIImage *)image {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(kWidth, imageView.frame.origin.y, image.size.width, image.size.height);
    } completion:^(BOOL finished) {
        imageView.frame = CGRectMake(-image.size.width, imageView.frame.origin.y, image.size.width, image.size.height);
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self rainingCloudMove2:duration imageView:imageView image:image];
        }
    }];
}

- (void)rainingCloudMove3_2:(UIImageView *)imageView image:(UIImage *)ele_middleRainCloud3 {
    CGFloat cloud3width = ele_middleRainCloud3.size.width / ele_middleRainCloud3.size.height * (kHeight / 2);
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(-(cloud3width - kWidth), 0, cloud3width, kHeight / 2);
    } completion:^(BOOL finished) {
        imageView.frame = CGRectMake(-(2 * cloud3width - kWidth), 0, cloud3width, kHeight / 2);
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self rainingCloudMove3_2:imageView image:ele_middleRainCloud3];
        }
    }];
}

- (void)rainingCloudMove3:(UIImageView *)imageView image:(UIImage *)ele_middleRainCloud3 {
    
    
    CGFloat cloud3width = ele_middleRainCloud3.size.width / ele_middleRainCloud3.size.height * (kHeight / 2);
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(kWidth, 0, cloud3width, kHeight / 2);
    } completion:^(BOOL finished) {
        imageView.frame = CGRectMake(-(cloud3width - kWidth), 0, cloud3width, kHeight / 2);
        if (self != nil || imageView != nil) {
            if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
                    [self rainingCloudMove3:imageView image:ele_middleRainCloud3];
            }
        }
    }];
}

#pragma mark - overcast
- (void)overcast {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_overcast" ofType:@"jpg"]];
    [self addSubview:backgroundView];
    
    UIImage *overcast_cloud1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overcast_cloud1" ofType:@"png"]];
    UIImage *overcast_cloud2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overcast_cloud2" ofType:@"png"]];
    UIImage *overcast_cloud3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overcast_cloud3" ofType:@"png"]];
    
    CGFloat cloud2Height = kWidth * overcast_cloud2.size.height / overcast_cloud2.size.width;
    
    UIImageView *overcast_cloud1View = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight * 600 / 1280 - 120, overcast_cloud1.size.width, overcast_cloud1.size.height)];
//    overcast_cloud1View.alpha = 0.5;
    UIImageView *overcast_cloud2View = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight * 260 / 1280, kWidth, cloud2Height)];
//    overcast_cloud2View.alpha = 0.3;
    UIImageView *overcast_cloud3View = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - overcast_cloud3.size.width, kHeight * 600 / 1280 - 120, overcast_cloud3.size.width, overcast_cloud3.size.height)];
    
    overcast_cloud1View.image = overcast_cloud1;
    overcast_cloud2View.image = overcast_cloud2;
    overcast_cloud3View.image = overcast_cloud3;
    
    [self addSubview:overcast_cloud1View];
    [self addSubview:overcast_cloud2View];
    [self addSubview:overcast_cloud3View];
    
    NSString *didCloseAnimation = [[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"];
    if ([didCloseAnimation isEqualToString:@"1"]) {
        [self overcastCloudMove2:4 imageView:overcast_cloud2View image:overcast_cloud2];
        [self overcastCloudMove1:5 imageView:overcast_cloud1View image:overcast_cloud1];
        [self overcastCloudMove3:5 imageView:overcast_cloud3View image:overcast_cloud3];
    }
}

- (void)overcastCloudMove3:(CGFloat)duration imageView:(UIImageView *)imageView image:(UIImage *)image {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
        imageView.center = CGPointMake(imageView.center.x - 50, imageView.center.y - 100);
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
            imageView.alpha = 0.0;
            imageView.center = CGPointMake(imageView.center.x - 50, imageView.center.y - 100);
        } completion:^(BOOL finished) {
            imageView.frame = CGRectMake(kWidth - image.size.width, kHeight * 600 / 1280 - 120, image.size.width, image.size.height);
            imageView.alpha = 1;
            if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
                [self overcastCloudMove3:duration imageView:imageView image:image];
            }
        }];
        
    }];
}

- (void)overcastCloudMove1:(CGFloat)duration imageView:(UIImageView *)imageView image:(UIImage *)image {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
        imageView.center = CGPointMake(imageView.center.x + 50, imageView.center.y - 100);
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
            imageView.alpha = 0.0;
            imageView.center = CGPointMake(imageView.center.x + 50, imageView.center.y - 100);
        } completion:^(BOOL finished) {
            imageView.frame = CGRectMake(0, kHeight * 600 / 1280 - 120, image.size.width, image.size.height);
            imageView.alpha = 1;
            if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
                [self overcastCloudMove1:duration imageView:imageView image:image];
            }
        }];
        
    }];
}

- (void)overcastCloudMove2:(CGFloat)duration imageView:(UIImageView *)imageView image:(UIImage *)image {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.5, 1.5);
        imageView.center = CGPointMake(imageView.center.x, imageView.center.y - 60);
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.5, 1.5);
            imageView.alpha = 0;
            imageView.center = CGPointMake(imageView.center.x, imageView.center.y - 60);
        } completion:^(BOOL finished) {
            imageView.frame = CGRectMake(0, kHeight * 260 / 1280, kWidth, kWidth * image.size.height / image.size.width);
            if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
                [self overcastCloudMove2:duration imageView:imageView image:image];
            }
        }];
        
    }];
}

#pragma mark - sunny(Day)
- (void)sunny {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_sunny" ofType:@"jpg"]];
    [self addSubview:backgroundView];
    
    UIImage *ele_sunnySun = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_sunnySun" ofType:@"png"]];
    UIImage *ele_sunnySunshine = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_sunnySunshine" ofType:@"png"]];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"ele_sunnyBird%d", i];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        [imageArr addObject:image];
    }
    NSMutableArray *imageArr2 = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"ele_sunnyBirdInvertedImage%d", i];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        [imageArr2 addObject:image];
    }
    UIImage *ele_sunnyCloud1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_sunnyCloud1" ofType:@"png"]];
    UIImage *ele_sunnyCloud2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ele_sunnyCloud2" ofType:@"png"]];

    
    UIImageView *ele_sunnySunView = [[UIImageView alloc] initWithImage:ele_sunnySun];
    ele_sunnySunView.center = CGPointMake(150, 150);
    UIImageView *ele_sunnySunshineView = [[UIImageView alloc] initWithImage:ele_sunnySunshine];
    ele_sunnySunshineView.center = ele_sunnySunView.center;
    UIImageView *ele_sunnyBirdView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ele_sunnyBirdView.center = CGPointMake(ele_sunnySunView.center.x, ele_sunnySunView.center.y + 30);
    ele_sunnyBirdView.animationImages = imageArr;
    ele_sunnyBirdView.animationDuration = 1.5;
    UIImageView *ele_sunnyBirdView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ele_sunnyBirdView2.center = CGPointMake(ele_sunnySunView.center.x, kHeight - 70);
    ele_sunnyBirdView2.animationImages = imageArr2;
    ele_sunnyBirdView2.animationDuration = 1.5;
    UIImageView *ele_sunnyCloud1View = [[UIImageView alloc] initWithFrame:CGRectMake(30, kHeight * 812 / 1136 - ele_sunnyCloud1.size.height / 2, ele_sunnyCloud1.size.width, ele_sunnyCloud1.size.height)];
    UIImageView *ele_sunnyCloud2View = [[UIImageView alloc] initWithFrame:CGRectMake(100, kHeight * 812 / 1136 - ele_sunnyCloud2.size.height / 2, ele_sunnyCloud2.size.width, ele_sunnyCloud2.size.height)];
    
    ele_sunnyCloud1View.image = ele_sunnyCloud1;
    ele_sunnyCloud2View.image = ele_sunnyCloud2;
    
    [self addSubview:ele_sunnySunView];
    [self addSubview:ele_sunnySunshineView];
    [self addSubview:ele_sunnyBirdView];
    [self addSubview:ele_sunnyBirdView2];
    [self addSubview:ele_sunnyCloud1View];
    [self addSubview:ele_sunnyCloud2View];
    
    NSString *didCloseAnimation = [[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"];
    if ([didCloseAnimation isEqualToString:@"1"]) {
        [self sunnyMove:ele_sunnySunView];
        [self sunnyMove:ele_sunnySunshineView];
        [ele_sunnyBirdView startAnimating];
        [self sunnyBirdMove:ele_sunnyBirdView];
        [ele_sunnyBirdView2 startAnimating];
        [self sunnyBirdMove:ele_sunnyBirdView2];
        [self sunnyCloudMove:15 imageView:ele_sunnyCloud1View image:ele_sunnyCloud1];
        [self sunnyCloudMove:20 imageView:ele_sunnyCloud2View image:ele_sunnyCloud2];
    }
}

- (void)sunnyCloudMove:(CGFloat)duration imageView:(UIImageView *)imageView image:(UIImage *)image {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(kWidth - 100, imageView.frame.origin.y, image.size.width, image.size.height);
    } completion:^(BOOL finished) {
        imageView.frame = CGRectMake(-image.size.width, imageView.frame.origin.y, image.size.width, image.size.height);
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            
            [self sunnyCloudMove:duration imageView:imageView image:image];
        }
    }];
}

- (void)sunnyBirdMove:(UIImageView *)birdView {
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        birdView.frame = CGRectMake(kWidth, birdView.frame.origin.y, birdView.frame.size.width, birdView.frame.size.height);
    } completion:^(BOOL finished) {
        birdView.frame = CGRectMake(-30, birdView.frame.origin.y, birdView.frame.size.width, birdView.frame.size.height);
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self sunnyBirdMove:birdView];
        }
        
    }];
}

- (void)sunnyMove:(UIImageView *)sunView {
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        sunView.transform = CGAffineTransformRotate(sunView.transform, 30);
    } completion:^(BOOL finished) {
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self sunnyMove:sunView];
        }
    }];
}

#pragma mark - cloudy(Day)
- (void)cloudy
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg1_cloudy_day" ofType:@"jpg"]];
    [self addSubview:backgroundView];
    
    UIImage *cloud4Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud4" ofType:@"png"]];
    UIImage *cloud3Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud3" ofType:@"png"]];
    UIImage *cloud2Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud2" ofType:@"png"]];
    UIImage *cloud1Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud1" ofType:@"png"]];
    UIImage *cloudy_day_water = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_water" ofType:@"png"]];
    
    self.cloudy_day_cloud4 = [[UIImageView alloc] initWithFrame:CGRectMake(- (cloud4Image.size.width - kWidth), kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height)];
    self.cloudy_day_cloud4_2 = [[UIImageView alloc] initWithFrame:CGRectMake(-(2 * cloud4Image.size.width - kWidth), kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height)];
    self.cloudy_day_cloud3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.cloudy_day_cloud4.frame.origin.y - cloud3Image.size.height + 220, cloud3Image.size.width, cloud3Image.size.height)];
    self.cloudy_day_cloud3_2 = [[UIImageView alloc] initWithFrame:CGRectMake(-300, self.cloudy_day_cloud4.frame.origin.y - cloud3Image.size.height + 250, cloud3Image.size.width, cloud3Image.size.height)];
    self.cloudy_day_cloud2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.cloudy_day_cloud3.frame.origin.y - cloud2Image.size.height + 380, cloud2Image.size.width, cloud2Image.size.height)];
    self.cloudy_day_cloud2_2 = [[UIImageView alloc] initWithFrame:CGRectMake(-400, self.cloudy_day_cloud3.frame.origin.y - cloud2Image.size.height + 400, cloud2Image.size.width, cloud2Image.size.height)];
    self.cloudy_day_cloud1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.cloudy_day_cloud4.frame.origin.y - cloud1Image.size.height - 50, cloud1Image.size.width, cloud1Image.size.height)];
    self.cloudy_day_cloud1_2 = [[UIImageView alloc] initWithFrame:CGRectMake(-200, self.cloudy_day_cloud4.frame.origin.y - cloud1Image.size.height - 60, cloud1Image.size.width, cloud1Image.size.height)];
    UIImageView *cloudy_day_waterView = [[UIImageView alloc] initWithFrame:CGRectMake(-(cloudy_day_water.size.width - kWidth), kHeight - cloudy_day_water.size.height, cloudy_day_water.size.width, cloudy_day_water.size.width)];
    
    self.cloudy_day_cloud4.image = cloud4Image;
    self.cloudy_day_cloud4_2.image = cloud4Image;
    self.cloudy_day_cloud3.image = cloud3Image;
    self.cloudy_day_cloud3_2.image = cloud3Image;
    self.cloudy_day_cloud2.image = cloud2Image;
    self.cloudy_day_cloud2_2.image = cloud2Image;
    self.cloudy_day_cloud1.image = cloud1Image;
    self.cloudy_day_cloud1_2.image = cloud1Image;
    cloudy_day_waterView.image = cloudy_day_water;
    
    [backgroundView addSubview:self.cloudy_day_cloud4];
    [backgroundView addSubview:self.cloudy_day_cloud4_2];
    [backgroundView addSubview:self.cloudy_day_cloud3];
    [backgroundView addSubview:self.cloudy_day_cloud3_2];
    [backgroundView addSubview:self.cloudy_day_cloud2];
    [backgroundView addSubview:self.cloudy_day_cloud2_2];
    [backgroundView addSubview:self.cloudy_day_cloud1];
    [backgroundView addSubview:self.cloudy_day_cloud1_2];
    [backgroundView addSubview:cloudy_day_waterView];

    NSString *didCloseAnimation = [[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"];
    if ([didCloseAnimation isEqualToString:@"1"]) {
        [self cloudyMove4];
        [self cloudyMove3:15 cloud3:self.cloudy_day_cloud3];
        [self cloudyMove3:20 cloud3:self.cloudy_day_cloud3_2];
        [self cloudyMove2:15 cloud2:self.cloudy_day_cloud2];
        [self cloudyMove2:20 cloud2:self.cloudy_day_cloud2_2];
        [self cloudyMove1:15 cloud1:self.cloudy_day_cloud1];
        [self cloudyMove1:20 cloud1:self.cloudy_day_cloud1_2];
        [self cloudyMoveSea:cloudy_day_waterView];
    }
    
}

- (void)cloudyMoveSea:(UIImageView *)cloudSea
{
    
    UIImage *cloudy_day_water = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_water" ofType:@"png"]];
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cloudSea.frame = CGRectMake(0, cloudSea.frame.origin.y, cloudSea.frame.size.width, cloudSea.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            [UIView animateWithDuration:10 animations:^{
                cloudSea.frame = CGRectMake(-(cloudy_day_water.size.width - kWidth), cloudSea.frame.origin.y, cloudSea.frame.size.width, cloudSea.frame.size.height);
            } completion:^(BOOL finished) {
                if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
                    [self cloudyMoveSea:cloudSea];
                }
            }];
        }
    }];
}

- (void)cloudyMove1:(CGFloat)duration cloud1:(UIImageView *)cloud1
{
    
    UIImage *cloud1Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud1" ofType:@"png"]];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cloud1.frame = CGRectMake(kWidth, self.cloudy_day_cloud1.frame.origin.y, cloud1Image.size.width, cloud1Image.size.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            cloud1.frame = CGRectMake(-cloud1Image.size.width, self.cloudy_day_cloud1.frame.origin.y, cloud1Image.size.width, cloud1Image.size.height);
        }
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self cloudyMove1:duration cloud1:cloud1];
        }
    }];
}

- (void)cloudyMove2:(CGFloat)duration cloud2:(UIImageView *)cloud2
{
    
    UIImage *cloud2Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud2" ofType:@"png"]];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cloud2.frame = CGRectMake(kWidth, self.cloudy_day_cloud2.frame.origin.y, cloud2Image.size.width, cloud2Image.size.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            cloud2.frame = CGRectMake(-cloud2Image.size.width, self.cloudy_day_cloud2.frame.origin.y, cloud2Image.size.width, cloud2Image.size.height);
        }
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self cloudyMove2:duration cloud2:cloud2];
        }
    }];
}

- (void)cloudyMove3:(CGFloat)duration cloud3:(UIImageView *)cloud3
{
    UIImage *cloud3Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud3" ofType:@"png"]];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cloud3.frame = CGRectMake(kWidth, self.cloudy_day_cloud3.frame.origin.y, cloud3Image.size.width, cloud3Image.size.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            cloud3.frame = CGRectMake(-cloud3Image.size.width, self.cloudy_day_cloud3.frame.origin.y, cloud3Image.size.width, cloud3Image.size.height);
        }
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self cloudyMove3:duration cloud3:cloud3];
        }
    }];
}

- (void)cloudyMove4
{
    UIImage *cloud4Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy_day_cloud4" ofType:@"png"]];
    [UIView animateWithDuration:25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.cloudy_day_cloud4.frame = CGRectMake(kWidth, kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height);
        self.cloudy_day_cloud4_2.frame = CGRectMake(- (cloud4Image.size.width - kWidth), kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            self.cloudy_day_cloud4.frame = CGRectMake(- (cloud4Image.size.width - kWidth), kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height);
            self.cloudy_day_cloud4_2.frame = CGRectMake(- (2 * cloud4Image.size.width - kWidth), kHeight * 675 / 1280 - cloud4Image.size.height / 2, cloud4Image.size.width, cloud4Image.size.height);
        }
        if (!_flag && [[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"1"]) {
            [self cloudyMove4];
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
