//
//  MyACScrollView.m
//  MyACScrollView
//
//  Created by weichuancheng on 16/1/2.
//  Copyright © 2016年 xmcqcc_001. All rights reserved.
//

#import "MyACScrollView.h"

#define VIEW_WIDTH  self.frame.size.width    // The width of MyACScrollView
#define kViewHeight self.frame.size.height   // The height of MyACScrollView

@interface MyACScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton      *invalidateTimerButton;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, assign) NSInteger      numberOfImageViews;
@property (nonatomic, strong) NSMutableArray<__kindof UIImageView *> *imageViewArray;
@property (nonatomic, strong) ImageViewTapActionBlock block;   // The block will be called when clicking on the current image

@end

@implementation MyACScrollView

+ (instancetype)myACScrollViewWithFrame:(CGRect)frame
{
    MyACScrollView *acScrollView = [[MyACScrollView alloc] initWithFrame:frame];
    return acScrollView;
}

+ (instancetype)myACScrollViewWithFrame:(CGRect)frame imageArray:(NSArray<__kindof UIImage *> *)imageArray
{
    MyACScrollView *acScrollView = [MyACScrollView myACScrollViewWithFrame:frame];
    acScrollView.imageArray = imageArray;
    return acScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray<__kindof UIImage *> *)imageArray
{
    self = [[MyACScrollView alloc] initWithFrame:frame];
    
    if (self) {
        self.imageArray = imageArray;
    }
    
    return self;
}

/**
 *  Add event for current imageView, the event will be fired when clicking
 *
 *  @param block   Event block
 */
- (void)addTapEventForImageViewWithBlock:(ImageViewTapActionBlock)block
{
    if (self.block != block) {
        self.block = block;
    }
}

/**
 *  Set default values for MyACScrollView
 */
- (void)setDefaultValue
{
    self.scrollInterval = 3.0;
    self.animateDuration = 0.6;
    self.initialPage = 1;
    self.userScrollEnabled = YES;
    self.pageControlPosition = MyACScrollViewPageControlCenter;
    self.imageViewcontentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

/**
 *  Overwrite super class method
 */
- (instancetype)init
{
    if ([super init]) {
        [self setDefaultValue];
    }

    return self;
}

/**
 *  Overwrite super class method
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultValue];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageArray != nil) {
        [self buildScrollView];
        [self buildPageControl];
        [self addImageViewsOnScrollView];
        [self addButtonOnScrollView];
        [self addTimerLoop];
    }
}

/**
 *  Build scrollView, its frame is equal to self.frame
 */
- (void)buildScrollView
{
    if (self.userScrollEnabled) {
        self.numberOfImageViews = 3;
    } else {
        self.scrollView.scrollEnabled = NO;
        self.numberOfImageViews = 2;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH * self.numberOfImageViews, kViewHeight);
    self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH * (self.numberOfImageViews - 2), 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    if (self.imageArray.count == 1) {
        self.scrollView.scrollEnabled = NO;
    }
}

/**
 *  Build pageControl
 */
- (void)buildPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.imageArray.count;
    switch (self.pageControlPosition) {
        case MyACScrollViewPageControlLeft:
            self.pageControl.frame = CGRectMake(6, kViewHeight - 20, self.pageControl.numberOfPages * 15, 20);
            break;
        case MyACScrollViewPageControlCenter:
            self.pageControl.frame = CGRectMake((VIEW_WIDTH - self.pageControl.numberOfPages * 15) / 2, kViewHeight - 20, self.pageControl.numberOfPages * 15, 20);
            break;
        case MyACScrollViewPageControlRight:
            self.pageControl.frame = CGRectMake(VIEW_WIDTH - 6 - self.pageControl.numberOfPages * 15, kViewHeight - 20, self.pageControl.numberOfPages * 15, 20);
            break;
            
        default:
            break;
    }
    self.pageControl.currentPage = self.initialPage - 1;
    [self addSubview:self.pageControl];
}

/**
 *  Add imageViews on the scrollView to display images, and make all images auto cycle scrolling
 */
- (void)addImageViewsOnScrollView
{
    self.imageViewArray = [NSMutableArray array];
    for (int i = 0; i < self.numberOfImageViews; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * VIEW_WIDTH, 0, VIEW_WIDTH, kViewHeight)];
        imageView.image = self.imageArray[(self.imageArray.count + self.initialPage + i - self.numberOfImageViews + 1) % self.imageArray.count];
        imageView.contentMode = self.imageViewcontentMode;
        [self.scrollView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}

/**
 *  Add a button on the scrollView to fire the click event
 */
- (void)addButtonOnScrollView
{
    self.invalidateTimerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.invalidateTimerButton.frame = CGRectMake(VIEW_WIDTH * (self.numberOfImageViews - 2), 0, VIEW_WIDTH, kViewHeight);
    [self.invalidateTimerButton addTarget:self action:@selector(imageViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.invalidateTimerButton];
}

/**
 *  The method will be called when the button(current image) was clicked
 */
- (void)imageViewButtonAction:(UIButton *)button
{
    if (self.block) {
        self.block(self.pageControl.currentPage + 1);
    }
}

/**
 *  Add timer to realize automatic scrolling
 */
- (void)addTimerLoop
{
    if (self.timer == nil && self.imageArray.count > 1) {
        if (!self.userScrollEnabled) {
            self.scrollView.scrollEnabled = NO;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(changeContentOffSet) userInfo:nil repeats:YES];
    }
}

/**
 *  Add animation for image switching, and change contentOffSet to realize cycle scrolling
 */
- (void)changeContentOffSet
{
    if (!self.userScrollEnabled) {
        self.scrollView.scrollEnabled = NO;
    }
    [UIView animateWithDuration:self.animateDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH * (self.numberOfImageViews - 1), 0);
        self.pageControl.currentPage = (self.imageArray.count + self.pageControl.currentPage + 1) % self.imageArray.count;
    } completion:^(BOOL finished) {
        if (self.userScrollEnabled) {
            self.imageViewArray[0].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage - 1) % self.imageArray.count];
        }
        self.imageViewArray[self.numberOfImageViews - 2].image = self.imageArray[self.pageControl.currentPage];
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH * (self.numberOfImageViews - 2), 0);
        self.imageViewArray[self.numberOfImageViews - 1].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage + 1) % self.imageArray.count];
    }];
}

/**
 *  Dealing with user-made sliding events
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(self.imageArray.count + self.pageControl.currentPage + self.scrollView.contentOffset.x / VIEW_WIDTH - 1) % self.imageArray.count;
    ;
    if (self.scrollView.contentOffset.x == 0) {
        self.imageViewArray[1].image = self.imageArray[self.pageControl.currentPage];
        self.imageViewArray[2].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage + 1) % self.imageArray.count];
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
        self.imageViewArray[0].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage - 1) % self.imageArray.count];
    }
    if (self.scrollView.contentOffset.x == 2 * VIEW_WIDTH) {
        self.imageViewArray[1].image = self.imageArray[self.pageControl.currentPage];
        self.imageViewArray[0].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage - 1) % self.imageArray.count];
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
        self.imageViewArray[2].image = self.imageArray[(self.imageArray.count + self.pageControl.currentPage + 1) % self.imageArray.count];
    }
    [self pauseTimer];   // Pause timer at the end of user-made sliding events
}

/**
 *  Pause timer
 */
- (void)pauseTimer //播放时间
{
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollInterval - self.animateDuration]];
    }
}

@end
