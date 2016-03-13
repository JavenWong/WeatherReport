//
//  RealisticViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/1.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "RealisticViewController.h"
#import "RealistModel.h"
#import "APIStoreSDK.h"
#import "RealisticCollectionViewCell.h"
#import "DetailListViewController.h"
#import "PictoralViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "PictorDetailViewController.h" // 测试网址


#define kscreenWith [UIScreen mainScreen].bounds.size.width

@interface RealisticViewController () <UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *realistArr;

@property (nonatomic, strong) UICollectionView *collectionviews;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, assign) int pageCount;

@end

@implementation RealisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"游记", @"趣闻"]];
    
    _segment.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width / 4.0 , 30);
    
    _segment.tintColor = [UIColor blackColor];
    
    [self.navigationItem setTitleView:_segment];
    
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    _segment.selectedSegmentIndex = 0;
    
    self.pageCount = 1;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.collectionviews];
    
    [self refresh];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _segment.selectedSegmentIndex = 0;

}

- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            
        break;
        case 1:
        {
            PictoralViewController *PictoralVC = [[PictoralViewController alloc]init];
            [self.navigationController pushViewController:PictoralVC animated:YES];
            
        }
            
        break;
            
        default:
            break;
    }
    
    
    
}

- (UICollectionView *)collectionviews
{
    if (_collectionviews == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kscreenWith - 15) / 2.0;
        flowLayout.itemSize = CGSizeMake(width, width / 125.0 * 130);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionviews = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        self.collectionviews.backgroundColor = [UIColor whiteColor];
        self.collectionviews.dataSource = self;
        self.collectionviews.delegate = self;
        
//        self.collectionviews.pagingEnabled = YES;
        
        // collectionView的cell必须经过注册
        [self.collectionviews registerClass:[RealisticCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
        
    }
    return _collectionviews;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    self.collectionviews.mj_footer.hidden = self.realistArr.count == 0;
    return self.realistArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RealisticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.contentView.layer.cornerRadius = 5.0f;
    cell.contentView.layer.borderWidth = 0.5f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    cell.realistModel = self.realistArr[indexPath.item];
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (void)refresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionviews.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
        
        [weakSelf.collectionviews.mj_header endRefreshing];
        
    }];
    
    [self.collectionviews.mj_header beginRefreshing];
    
    
    // 上拉刷新
    self.collectionviews.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadTotalData];

       [weakSelf.collectionviews.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.collectionviews.mj_footer.hidden = YES;
}

// 上拉刷新进行的操作
- (void)loadTotalData
{
    
    self.pageCount++;
//    NSLog(@"正在添加第%d页的数据", self.pageCount);
    [self loadData:self.pageCount];
    
}


// 下拉刷新进行的操作
- (void)refreshData
{
    [self.realistArr removeAllObjects];
    for (int i = 0; i < self.pageCount; i++) {
        [self loadData:i + 1];
        
    }
//    NSLog(@"下拉刷新____pageCount的数值为%d", self.pageCount);
}



- (NSMutableArray *)realistArr
{
    
    if (_realistArr == nil) {
        _realistArr = [NSMutableArray array];
    }
    return _realistArr;
    
}

- (void)loadData:(NSInteger)page
{
    NSString *keyName = @"5b3c230b6b40fcb10287e9e29184bc6f";
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        if(responseString != nil) {
            
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            [self dealWithModel:dic];
            
            
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
    };

    
    //部分参数
    NSString *uri = @"http://apis.baidu.com/qunartravel/travellist/travellist";
    
    NSString *method = @"get";
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    NSString *httpArg = [NSString stringWithFormat: @"query=%22%22&page=%ld", (long)page];
    
//    NSLog(@"正在解析第%ld页的数据",(long)page);
    [parameter setObject:httpArg forKey:@"httpArg"];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:keyName parameter:parameter callBack:callBack];
    
    
}

// 下拉时设置tabBar消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_collectionviews.contentOffset.y > 1) {
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

// 停止滑动时显示tarBar
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.tabBarController.tabBar.hidden = NO;    
}


- (void)dealWithModel:(NSDictionary *)dic
{
    
    NSArray *array = dic[@"data"][@"books"];

    for (NSDictionary *dictionary in array) {
        RealistModel *model = [[RealistModel alloc]init];
        [model setValuesForKeysWithDictionary:dictionary];
        
        [self.realistArr addObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionviews reloadData];
        });
    }
    
//    NSLog(@"____数组里的model个数为%ld", (unsigned long)self.realistArr.count);
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RealistModel *model = self.realistArr[indexPath.row];

    DetailListViewController *detailVC = [[DetailListViewController alloc]init];
    detailVC.realistModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];

    
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
