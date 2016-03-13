//
//  DetailNewsViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "DetailNewsViewController.h"
#define URL @"http://c.m.163.com/nc/article/BHDEDC9G0004662N/full.html"
@interface DetailNewsViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.webView.scalesPageToFit = YES;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
//    NSString *str1 = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/BHDEDC9G0004662N/full.html"];
//    NSString *str2 = [str1 stringByReplacingCharactersInRange:NSMakeRange(30, 16) withString:self.postid];
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
