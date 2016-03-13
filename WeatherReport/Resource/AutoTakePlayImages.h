//
//  AutoTakePlayImages.h
//  151113-轮播
//
//  Created by 黄红荫 on 16/2/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 AutoTakePlayImages 自动轮播的封装
 参数说明：
      1.number - 轮播多少张图片
      2.viewController - 指定视图控制器
      3.scrollView - 指定滚动视图
      4.pageView - 指定页面控制器
      5.index －指定当前滚动页面
 
 ／／ 具体用法：
 
 #import "ViewController.h"
 #import "AutoTakePlayImages.h"
 #define M 5
 
 @interface ViewController ()<UIScrollViewDelegate>
 @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
 @property (weak, nonatomic) IBOutlet UIPageControl *pageView;
 @property (nonatomic ,strong)NSTimer * timer;
 @property (nonatomic ,assign) CGPoint scrollPoinit;
 @property (nonatomic ,assign) NSInteger  index;
 @property(nonatomic,strong)AutoTakePlayImages *autoPlay;
 @end
 
 @implementation ViewController
 -(AutoTakePlayImages*)autoPlay
 {
 if (!_autoPlay) {
 _autoPlay = [[AutoTakePlayImages alloc]init];
 }
 return _autoPlay;
 }
 
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 [self.autoPlay addImageNumber:M UIViewController:self UIScrollView:self.scrollView UIPageControl:self.pageView];
 self.scrollView.delegate=self;
 [self timer];
 
 }
 当前的拖动位置
 -(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 [self.autoPlay scrollPositionNumber:M ScrollView:self.scrollView index:self.index UIPageControl:self.pageView];
 }
 
 -(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 [self.timer invalidate];
 self.timer=nil;
 }
 
 降速结束后调用
 -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 [self.autoPlay test:M index:self.index scrollView:self.scrollView pageView:self.pageView];
 [self.autoPlay changeContentOffset:M index:self.index scrollView:self.scrollView pageView:self.pageView];
 当减速结束后调用定时器
 [self timer];
 }
 -(NSTimer *)timer{
 if (_timer==nil) {
 _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector( nextPage) userInfo:nil repeats:YES];
 }
 把当前的定时器添加到当前的运行循环中,并指定它为通用模式,这样主线程在执行的时候就可以抽那么一点时间来关注一下我们的定时器
 [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
 return _timer;
 }
 #pragma mark -自动调用方法
 -(void)nextPage{
 [self.autoPlay nextPage:M scrollView:self.scrollView pageView:self.pageView];
 }
 
*/




@interface AutoTakePlayImages : NSObject

-(void)addImageNumber:(int)number UIViewController:(UIViewController*)viewController UIScrollView:(UIScrollView*)scrollView UIPageControl:(UIPageControl*)pageView;
-(void)scrollPositionNumber:(int)number ScrollView:(UIScrollView*)scrollView index:(NSInteger)index UIPageControl:(UIPageControl*)pageView;
-(void)nextPage:(int)number scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView;
-(void)changeContentOffset:(int)number index:(NSInteger)index scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView;
-(void)test:(int)number index:(NSInteger)index scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView;
@end

