//
//  PictorDetailTableViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/9.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "PictorDetailTableViewController.h"
#import "WHHTTPSessionManager.h"
#import "ZKRArticleDetailTopView.h"
#import "UIView+Init.h"
#import "MJExtension.h"
#import "ArticleContentItem.h"
#import "UIView+Frame.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
@interface PictorDetailTableViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) ArticleContentItem *contentItem;

@end

@implementation PictorDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKRArticleCommentCell class]) bundle:nil] forCellReuseIdentifier:ArticleCommentCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 35, 0);
    [SVProgressHUD show];
    [self setupTableHeaderView];
    
    [self loadWebData];
    
}


#pragma mark - ---| 加载view |---
- (void)setupTableHeaderView
{
    
    ZKRArticleDetailTopView *topView = [ZKRArticleDetailTopView cgl_viewFromXib];
    topView.frame = CGRectMake(0, -120, kscreenWidth, 120);
    topView.item = self.item;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, 350)];
    webView.delegate                 = self;

    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.contentInset  = UIEdgeInsetsMake(120, 0, 0, 0);
    
    [webView.scrollView addSubview:topView];
    self.webView = webView;
}


- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
//    view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:view];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
}


/** 加载网页信息 */
- (void)loadWebData
{
    NSString *url = self.item.full_url;
    NSLog(@"%@", url);
   
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [self.manager GET:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ArticleContentItem *contentItem  = [ArticleContentItem mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.contentItem = contentItem ;
        
        [self loadWebView:self.contentItem];
        [self.webView reload];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

/** 设置网页内容格式 */
- (void)loadWebView:(ArticleContentItem *)contentItem
{
    NSMutableString *html = [NSMutableString string];
    // 头部内容
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"</head>"];
    
    // 具体内容
    [html appendString:@"<body>"];
    
    [html appendString:[self setupBody:contentItem]];
    
    [html appendString:@"</body>"];
    
    // 尾部内容
    [html appendString:@"</html>"];
    
    // 显示网页
    [self.webView loadHTMLString:html baseURL:nil];
}

/**
 *  初始化网页body内容
 */
- (NSString *)setupBody:(ArticleContentItem *)contentItem
{
    NSMutableString *body = [NSMutableString stringWithFormat:@"%@",contentItem.content];
    
    
    [contentItem.media enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableString *m_url = obj[@"m_url"];
        
        // 原div点击事件
        NSMutableString *div   = [NSMutableString stringWithFormat:@"onclick='window.location.href=\"http://www.myzaker.com/?_zkcmd=open_media&index=%zd\"'", idx];
        // 替换的div点击事件
        NSMutableString *reDiv = [NSMutableString stringWithFormat:@"onclick='alert(this.src)'"];
        
        [body replaceOccurrencesOfString:div withString:reDiv options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        
        
        
        NSString *imgTargetString  = [NSString stringWithFormat:@"id=\"id_image_%zd\" class=\"\" src=\"article_html_content_loading.png\"", idx];
        NSString *imgReplaceString = [NSString stringWithFormat:@"id=\"id_image_%zd\" class=\"\" src=\"%@\"", idx, m_url];
        
        [body replaceOccurrencesOfString:imgTargetString withString:imgReplaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }];
//        NSLog(@"%@", body);
    return body;
}

#pragma mark - ---| webView delegate |---
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /** 加载后的webView高度 */
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    
    /** webView新增底部view */
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, webViewHeight + 20, kscreenWidth, 100)];
    
    [webView.scrollView addSubview:view];
    
    webView.cgl_height = webViewHeight + 120 + 20 + 100;
    
    self.tableView.tableHeaderView = webView;
    
    [self.tableView reloadData];
    
    // 在网页加载后加载评论
//    [self loadCommentData];
    [SVProgressHUD dismiss];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
