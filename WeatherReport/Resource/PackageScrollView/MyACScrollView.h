//
//  MyACScrollView.h
//  MyACScrollView
//
//  Created by weichuancheng on 16/1/2.
//  Copyright © 2016年 xmcqcc_001. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Values for MyACScrollViewPageControlPosition
 */
typedef NS_ENUM(NSInteger, MyACScrollViewPageControlPosition) {
    MyACScrollViewPageControlCenter, // default. Visually centered
    MyACScrollViewPageControlLeft,   // Visually left aligned
    MyACScrollViewPageControlRight   // Visually right aligned
};

/**
 *  The block will be called when clicking on the current image
 *
 *  @param imageIndex   The index of the current image, form 1 to imageArray.count
 */
typedef void(^ImageViewTapActionBlock)(NSInteger imageIndex);

@interface MyACScrollView : UIView

@property (nonatomic, assign) NSTimeInterval    scrollInterval;                        // default is 3.0. Interval of image scroll
@property (nonatomic, assign) NSTimeInterval    animateDuration;                       // default 0.6. Duration of image switching animation
@property (nonatomic, assign) NSInteger         initialPage;                           // default 1. Default initially display the first image in the imageArray
@property (nonatomic, assign) UIViewContentMode imageViewcontentMode;                  // default UIViewContentModeScaleAspectFill
@property (nonatomic, assign) BOOL              userScrollEnabled;                     // default YES. if NO, user will can not affect the scroll of images
@property (nonatomic, strong) NSArray<__kindof UIImage *> *imageArray;                 // Images will displayed on the scrollView
@property (nonatomic, assign) MyACScrollViewPageControlPosition pageControlPosition;   // default MyACScrollViewPageControlCenter

+ (instancetype)myACScrollViewWithFrame:(CGRect)frame;

+ (instancetype)myACScrollViewWithFrame:(CGRect)frame imageArray:(NSArray<__kindof UIImage *> *)imageArray;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray<__kindof UIImage *> *)imageArray;

/**
 *  Add event for current imageView, the event will be fired when clicking
 *
 *  @param block   Event block
 */
- (void)addTapEventForImageViewWithBlock:(ImageViewTapActionBlock)block;

@end
