//
//  AutoTakePlayImages.m
//  151113-轮播
//
//  Created by 黄红荫 on 16/2/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "AutoTakePlayImages.h"


@interface AutoTakePlayImages ()


@end

@implementation AutoTakePlayImages


-(void)addImageNumber:(int)number UIViewController:(UIViewController *)viewController UIScrollView:(UIScrollView *)scrollView UIPageControl:(UIPageControl *)pageView
{
    //scrollView 的总偏移量：self.scrollView.bounds.size.width*(M+2)
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width*(number+2), 0);
    CGFloat imageX=0;
    CGFloat imageY=0;
    CGFloat imageH=scrollView.bounds.size.height;
    CGFloat imageW=scrollView.bounds.size.width;
    //添加照片多添加了两张
    for (NSInteger i=0; i<number+2; i++) {
        if (i==0) { // 第一张照片
            UIImageView *imageView=[[UIImageView alloc ]init];
            
            imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
            
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",number]];
            
            [scrollView addSubview:imageView];
        }else if(i==number+1) { //最后一张照片
            UIImageView *imageView=[[UIImageView alloc ]init];
            imageX=imageW*i; // 偏移量
            imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
            
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",1]];
            
            [scrollView addSubview:imageView];
        } else {
            UIImageView *imageView=[[UIImageView alloc ]init];
            imageX=imageW*i;
            imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
            
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02ld",i]];
            
            [scrollView addSubview:imageView];
        }
    }
    scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    scrollView.pagingEnabled=YES;
    // 3.隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 4.隐藏垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    pageView.pageIndicatorTintColor=[UIColor purpleColor];
    pageView.numberOfPages=number;
    pageView.currentPage=0;
    pageView.currentPageIndicatorTintColor=[UIColor blueColor];



}

-(void)scrollPositionNumber:(int)number ScrollView:(UIScrollView *)scrollView index:(NSInteger)index UIPageControl:(UIPageControl *)pageView
{
    CGFloat maxW = scrollView.bounds.size.width;
    NSInteger page = (scrollView.contentOffset.x +maxW*0.5)/maxW;
    index = page;
    // 判断最后一张图片的偏移量，向右拖动如果拖动的偏移量大于一半，设置当前的 self.index = 1
    if (scrollView.contentOffset.x > maxW *(number + 0.5))
        page = 1;
    else if (scrollView.contentOffset.x <maxW*0.5) // 判断第一张图片的偏移量，向左拖动如果拖动的偏移量大于一半，设置当前的 self.index = M
        page = number;
    pageView.currentPage = page-1;
}

-(void)nextPage:(int)number scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView{
    //获取当前页码
    NSInteger pageCount=pageView.currentPage;
    //判断如果页码为4则证明为最后一页
    if (pageCount==number-1) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        pageCount=0;
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0) animated:YES];
        
    }else{
        pageCount++;
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width*(pageCount+1), 0) animated:YES];
    }
    pageView.currentPage = pageCount;
}

-(void)changeContentOffset:(int)number index:(NSInteger)index scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView
{
    CGFloat maxW = scrollView.bounds.size.width;
    // 改变偏移量
    if (index == number +1)
        scrollView.contentOffset = CGPointMake(maxW, 0);
    else if (index == 0)
        scrollView.contentOffset = CGPointMake(maxW *number, 0);

}
#pragma mark - 自动调用代码
-(void)test:(int)number index:(NSInteger)index scrollView:(UIScrollView*)scrollView pageView:(UIPageControl*)pageView
{
    
    if (scrollView.contentOffset.x > scrollView.frame.size.width*(number)) {
        pageView.currentPage=0;
        scrollView.contentOffset=CGPointMake(scrollView.bounds.size.width, 0);
    }
    if(scrollView.contentOffset.x < scrollView.frame.size.width*0.5){
        pageView.currentPage = number -1;
        scrollView.contentOffset=CGPointMake(scrollView.bounds.size.width*number, 0);
    }
    
}



@end

