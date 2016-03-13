//
//  PictorDetailViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "PictorDetailViewController.h"
#import "WHHTTPSessionManager.h"

#import "ArticleContentItem.h"
#import "PictorDetailTableViewController.h"


@interface PictorDetailViewController ()



@property (nonatomic, strong) PictoralModel *contentItem;

@property (nonatomic, strong) PictorDetailTableViewController *articleVC;

@end

@implementation PictorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.weburl]];
//    [self.view addSubview:_webView];
//    [_webView loadRequest:request];

   
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    PictorDetailTableViewController *articleDetailVC = [[PictorDetailTableViewController alloc]init];
    articleDetailVC.item = self.model;
    [self.view addSubview:articleDetailVC.view];
    self.articleVC = articleDetailVC;
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];}






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
