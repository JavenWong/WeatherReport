//
//  DetailListViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/4.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "DetailListViewController.h"

#import "UIImageView+WebCache.h"

#import "Reachability.h"
#import "MBProgressHUD.h"
#import "PictureViewController.h"

#define kscreenWith [UIScreen mainScreen].bounds.size.width

@interface DetailListViewController ()


@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic , strong) UILabel *startTimeLabel; // 开始时间

@property (nonatomic, strong) UILabel *userLbabel; // 作者名称

@property (nonatomic, strong) UILabel *routeDays; // 旅游天数

@property (nonatomic, strong) UIImageView *userImage; // 作者图片

@property (nonatomic, strong) UILabel *locationLb; // 途经地点


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self recordScale];
    
    [self requestData];
    
    
}


// 记录比例
- (void)recordScale
{
    
    SDWebImageManager *sdImage = [SDWebImageManager sharedManager];
    NSString *key = [sdImage cacheKeyForURL:[NSURL URLWithString:_realistModel.headImage]];
    
    NSString *keyPath = [sdImage.imageCache defaultCachePathForKey:key];
    
    CGSize size = [UIImage imageWithContentsOfFile:keyPath].size;
    
    // 对除数是否为0进行判断, 是0不执行
    if (size.height != 0) {
        _realistModel.scale = size.height / size.width;
        _realistModel.width = size.width;
        _realistModel.height = size.height;
        NSLog(@"______比例为%f", self.realistModel.scale);
       
        
    }
    
    
}

- (BOOL)isnetWork
{
    BOOL isnetwork;
    
    Reachability *reach = [Reachability reachabilityWithHostName:self.realistModel.headImage];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没网络");
            isnetwork = NO;
            break;
        case ReachableViaWiFi:
            isnetwork = YES;
            break;
        case ReachableViaWWAN:
            isnetwork = YES;
            break;
        default:
            break;
    }
    return isnetwork;
}



- (void)requestData
{
    
    if ([self isnetWork]) {
        [self showHUDwith:@"正在加载"];
        
        [self loadData];
    
    }
    
    else
    {
        
        [self showHUDStringWith:@"网络状况不好, 请检查网络!"];
        
    }
    
}

// 加在图片上的视图
- (void)loadData
{
    
    // 加载背景图片
    if (self.realistModel.scale != 0) {
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kscreenWith, kscreenWith * self.realistModel.scale)];
    _imageview.contentMode =  UIViewContentModeScaleAspectFill;
    }

    else
    {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kscreenWith, kscreenWith * 0.7)];
        _imageview.contentMode =  UIViewContentModeScaleAspectFit;
        
    }
    [self.scrollview addSubview:self.imageview];
    [self.imageview sd_setImageWithURL:[[NSURL alloc] initWithString:self.realistModel.headImage] placeholderImage:[UIImage imageNamed:@"default_icon@2x"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    // 为图片增加点击方法
    self.imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(watchtheBigImage:)];
    [self.imageview addGestureRecognizer:singleTap];
        
        
    [self hideHUD];
        
        
    }];
    
    // 标题名称
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageview.frame) + 20, 200, 30)];
    titleLB.text = self.realistModel.title;
    [titleLB sizeToFit];
    [self.scrollview addSubview:titleLB];
    
    // 作者图片
    self.userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLB.frame) + 20, 32, 32)];
    self.userImage.layer.cornerRadius = 32.0 / 2;
    self.userImage.clipsToBounds = YES;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.realistModel.userHeadImg]];
    [self.scrollview addSubview:self.userImage];
    
    // 作者名称
    self.userLbabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10, CGRectGetMaxY(titleLB.frame) + 25, 100, 30)];
    self.userLbabel.backgroundColor = [UIColor whiteColor];
    self.userLbabel.text = self.realistModel.userName;
    [self.userLbabel sizeToFit];
    [self.scrollview addSubview:self.userLbabel];
    
    // 出发小图标
    UIImageView *travelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.userImage.frame) + 20, 20, 20)];
    travelImageView.layer.cornerRadius = 20.0 / 2;
    travelImageView.clipsToBounds = YES;
    travelImageView.image = [UIImage imageNamed:@"chufa.png"];
    [self.scrollview addSubview:travelImageView];
    
    UILabel *startLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(travelImageView.frame) + 10, CGRectGetMaxY(self.userImage.frame) + 20, 100, 30)];
    startLB.text = @"出发日期:";
    [startLB sizeToFit];
    [self.scrollview addSubview:startLB];
    
    // 出发日期
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startLB.frame) + 10, CGRectGetMaxY(self.userImage.frame) + 15, 100, 30)];
    self.startTimeLabel.text = self.realistModel.startTime;
    [self.scrollview addSubview:self.startTimeLabel];
    
    // 天数
    UIImageView *routeDaysImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.startTimeLabel.frame) + 20, 20, 20)];
    routeDaysImageView.image = [UIImage imageNamed:@"days.png"];
    [self.scrollview addSubview:routeDaysImageView];
    
    self.routeDays = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(routeDaysImageView.frame) + 10, CGRectGetMaxY(self.startTimeLabel.frame) + 15, 100, 30)];
    self.routeDays.text = [NSString stringWithFormat:@"天数: %.0f", self.realistModel.routeDays];
    [self.scrollview addSubview:self.routeDays];
    
    self.locationLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_routeDays.frame) + 20, kscreenWith - 30, 30)];
    self.locationLb.text = [NSString stringWithFormat:@"途经地点: %@", self.realistModel.text];
    self.locationLb.numberOfLines = 0;
    [self.locationLb sizeToFit];
    [self.scrollview addSubview:self.locationLb];
    
    
}

- (void)watchtheBigImage:(UITapGestureRecognizer *)gesture
{
    
   
    PictureViewController *viewController = [[PictureViewController alloc]init];
//    viewController.urlStr = self.realistModel.headImage;
    viewController.picturemodel = self.realistModel;
//    [self presentViewController:viewController animated:NO completion:NULL];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)showHUDwith:(NSString *)str
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.tag = 10;
    hud.labelText = str;
    [hud show:YES];
    [self.view addSubview:hud];
    //    [hud hide:YES afterDelay:2];
    
}

- (void)hideHUD
{
    MBProgressHUD *HUD = (MBProgressHUD *)[self.view viewWithTag:10];
    [HUD hide:YES];
    
}

- (void)showHUDStringWith:(NSString *)str
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    [hud show:YES];
    [self.view addSubview:hud];
    [hud hide:YES afterDelay:2];
    
    
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
