//
//  BackgroundAnimationViewController.m
//  WeatherReport
//
//  Created by JavenWong on 16/3/11.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "BackgroundAnimationViewController.h"
#import "SetBackgroundImageByCond.h"

@interface BackgroundAnimationViewController ()

@property (strong, nonatomic) NSMutableArray *condArr;
@property (strong, nonatomic) SetBackgroundImageByCond *condView;
@property (strong, nonatomic) UILabel *condLb;
@property (assign, nonatomic) NSInteger i;

@end

@implementation BackgroundAnimationViewController

- (NSMutableArray *)condArr {
    if (_condArr == nil) {
        _condArr = [NSMutableArray arrayWithObjects:@"晴", @"多云", @"阴", @"雨", nil];
    }
    return _condArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *emptyImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:emptyImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = emptyImage;
    UIBarButtonItem *getBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStyleDone target:self action:@selector(getBackBtnAction:)];
    self.navigationItem.leftBarButtonItem = getBackBtn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = YES;

    
    self.i = 0;
    self.condView = [[SetBackgroundImageByCond alloc] initWithFrame:self.view.frame];
    self.condView.flag = NO;
    [self.condView SetBackgroundImageByCond:self.condArr[self.i]];
    [self.view addSubview:self.condView];
    
    self.condLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 60)];
    self.condLb.text = self.condArr[self.i];
    self.condLb.textColor = [UIColor whiteColor];
    self.condLb.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:self.condLb];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.condView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.condView addGestureRecognizer:rightSwipe];
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)leftSwipe {
    
    if (self.i < self.condArr.count - 1) {
        self.i += 1;
        self.condView.flag = YES;
        [self.condView removeFromSuperview];
        self.condView = nil;
        self.condView = [[SetBackgroundImageByCond alloc] initWithFrame:self.view.frame];
        [self.condView SetBackgroundImageByCond:self.condArr[self.i]];
        [self.view addSubview:self.condView];
        self.condLb.text = self.condArr[self.i];
        [self.view bringSubviewToFront:self.condLb];
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.condView addGestureRecognizer:leftSwipe];
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.condView addGestureRecognizer:rightSwipe];
    }
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)rightSwipe {
    
    if (self.i > 0) {
        self.i -= 1;
        self.condView.flag = YES;
        [self.condView removeFromSuperview];
        self.condView = nil;
        self.condView = [[SetBackgroundImageByCond alloc] initWithFrame:self.view.frame];
        [self.condView SetBackgroundImageByCond:self.condArr[self.i]];
        [self.view addSubview:self.condView];
        self.condLb.text = self.condArr[self.i];
        [self.view bringSubviewToFront:self.condLb];
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.condView addGestureRecognizer:leftSwipe];
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.condView addGestureRecognizer:rightSwipe];
    }
}

- (void)getBackBtnAction:(UIBarButtonItem *)item {
    self.condView.flag = YES;
    [self.condView removeFromSuperview];
    self.condView = nil;
    [self.navigationController popViewControllerAnimated:YES];
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
