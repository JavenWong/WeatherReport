//
//  PictureViewController.m
//  WeatherReport
//
//  Created by lanou on 16/3/8.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "PictureViewController.h"
#import "UIImageView+WebCache.h"
#import "ZDPicDetailView.h"

#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height

@interface PictureViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UIImageView *imageview;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看大图";
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [saveButton setBackgroundImage:[UIImage imageNamed:@"savebutton.png"] forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, 54, 36);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [saveButton addTarget:self action:@selector(savePicture:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    
    {

//    SDWebImageManager *sdImage = [SDWebImageManager sharedManager];
//    NSString *key = [sdImage cacheKeyForURL:[NSURL URLWithString:self.picturemodel.headImage]];
//    
//    NSString *keyPath = [sdImage.imageCache defaultCachePathForKey:key];
//    
//    CGSize size = [UIImage imageWithContentsOfFile:keyPath].size;
//    float scale = size.height / size.width;
//    self.imageview.center = self.view.center;
//    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, (kscreenHeight - kscreenWidth * scale) / 2.0 - 50, kscreenWidth, kscreenWidth * scale)];
        
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight - 40)];
//    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.picturemodel.headImage]];

    

    }
//    ZDPicDetailView *sc = [[ZDPicDetailView alloc] initWithFrame:self.view.bounds imageUrl:self.picturemodel.headImage];
    
    ZDPicDetailView *sv = [[ZDPicDetailView alloc] initWithFrame:self.view.bounds image:self.imageview.image];
    
    
  
    [self.view addSubview:sv];
    self.imageview.center = self.view.center;

}

- (void)savePicture:(UIBarButtonItem *)barButton
{
    
    UIImageWriteToSavedPhotosAlbum(self.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(!error)
    {
        NSLog(@"savesuccess");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:NULL];
        
        
    }
    else{
        NSLog(@"savefailed");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:NULL];
        
        
    }
    
    
    
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
