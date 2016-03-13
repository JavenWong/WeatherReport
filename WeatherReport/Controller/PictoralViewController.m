//
//  PictoralViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "PictoralViewController.h"
#import "PictoralModel.h"
#import "PictoralCollectionViewCell.h"
#import "PictorDetailViewController.h"

#import "WHHTTPSessionManager.h"

#import "AFNetworking.h"


#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height

@interface PictoralViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSArray *pictorealArr;

@property (nonatomic, strong) UICollectionView *collectionviews;

@property (nonatomic, strong) NSMutableArray *pictorelArray;

@property (nonatomic, strong) WHHTTPSessionManager *manager;
@end

@implementation PictoralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"游记", @"趣闻"]];
    
    segment.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width / 4.0 , 30);
    
    segment.tintColor = [UIColor blackColor];
    
    [self.navigationItem setTitleView:segment];
    
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    segment.selectedSegmentIndex = 1;
    
    // 隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 隐藏表视图
    self.tabBarController.tabBar.hidden = YES;
    

    [self loadData];
    [self setupCollectionView];
    

    self.navigationController.navigationBar.translucent = NO;
    
//    [self getPageOfArray];

    // 防止出现提示
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupCollectionView
{

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        flowLayout.itemSize = CGSizeMake(kscreenWidth, kscreenHeight - 49);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 49, 0);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionviews = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        self.collectionviews.backgroundColor = [UIColor whiteColor];
        self.collectionviews.dataSource = self;
        self.collectionviews.delegate = self;
        
        self.collectionviews.pagingEnabled = YES;
        
        // collectionView的cell必须经过注册
        
        // 用xib必须用以下代码注册
        [self.collectionviews registerNib:[UINib nibWithNibName:@"PictoralCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"reuseable"];

    [self.view addSubview:self.collectionviews];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        
    return self.pictorelArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictoralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseable" forIndexPath:indexPath];
    
    cell.articleArray = self.pictorelArray[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        case 1:
            break;
            
        default:
            break;
    }

}


// 获取时间戳
- (NSTimeInterval)getTimeInterval
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeIn = [date timeIntervalSince1970];
    NSLog(@"1970距离现在的时间秒数,%.0f", timeIn);
    return timeIn;
}

// 处理数据
- (void)loadData
{
    
    NSString *string = [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/blog2news.php?_appid=androidphone&_bsize=480_800&_version=6.46&app_id=11967&nt=2&since_date=%f", [self getTimeInterval]];

        self.manager = [WHHTTPSessionManager manager];
        [self.manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        self.pictorealArr = responseObject[@"data"][@"articles"];
//            NSLog(@"______%@", self.pictorealArr);
        NSInteger count = self.pictorealArr.count;
        
        NSMutableArray *page = [NSMutableArray arrayWithCapacity:6];
        NSMutableArray *pages = [NSMutableArray array];
       
        for (int i = 0; i < count; i++) {

             PictoralModel *article = [[PictoralModel alloc] init];
            [article setValuesForKeysWithDictionary:self.pictorealArr[i]];
            [page addObject:article];
            while (page.count == 6) {
                [pages addObject:page];
                page = [NSMutableArray arrayWithCapacity:6];
            }
        }
        self.pictorelArray = pages;
        
        
        [self.collectionviews reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
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
