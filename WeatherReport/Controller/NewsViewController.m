//
//  NewsViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/3.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "NewsViewController.h"
#import "MBProgressHUD.h"
#import "News.h"
#import "topNews.h"
#import "NewsTableViewCell.h"

#import "SDCycleScrollView.h"


#import "DetailNewsViewController.h" 
#import "UIImageView+WebCache.h"
#import "AAViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define URL @"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,retain)MBProgressHUD *progressHud;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)NSMutableArray *stringArr;

@property (nonatomic,strong)NSMutableArray *topDataArr;

@property (nonatomic,strong)NSMutableArray *imageArr;

@property (nonatomic,strong)UIImageView *imageV;

@property (nonatomic,assign)NSInteger last;

@property (nonatomic,strong)UIView *lunboView;

@property (nonatomic,strong)SDCycleScrollView *bannerView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
    [self getdata];
    [self loadTableview];
}

- (void)getdata{
    _dataArr = [NSMutableArray array];
    _topDataArr = [NSMutableArray array];
    _stringArr = [NSMutableArray array];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        NSArray *arr = [dic valueForKey:@"T1348647853363"];
        //头条
        NSDictionary *roll = arr[0];
        NSArray *lunboArr = [roll valueForKey:@"ads"];
        for (NSDictionary *dic in lunboArr) {
            topNews *top = [[topNews alloc]init];
            [top setValuesForKeysWithDictionary:dic];
            [_topDataArr addObject:top];
            [_stringArr addObject:top.imgsrc];
        }
        for (NSDictionary *dic1 in arr) {
       
            News *news = [[News alloc]init];
            [news setValuesForKeysWithDictionary:dic1];
            if (![news.digest isEqualToString:@""]&& !(news.digest == nil)&&!(news.url == nil)&&(![news.url isEqualToString:@"null"])&&(![news.url isEqualToString:@""])) {
                [_dataArr addObject:news];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
        });
    }];
    [task resume];
}

- (void)loadTableview{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"reuseIdentifier"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    News *news = self.dataArr[indexPath.row];
    cell.news = news;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.lunboView = [[UIView alloc]init];
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160) imageURLStringsGroup:self.stringArr];
//    self.bannerView.imageURLStringsGroup = self.stringArr;
//    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;

        [self.lunboView addSubview:self.bannerView];

    return self.lunboView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
    News *news = self.dataArr[indexPath.row];
    detailNews.url = news.url;
    [self.navigationController pushViewController:detailNews animated:YES];
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
