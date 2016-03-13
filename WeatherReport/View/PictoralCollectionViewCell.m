//
//  PictoralCollectionViewCell.m
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "PictoralCollectionViewCell.h"
#import "PictorDetailViewController.h"
#import "UIView+Init.h"
#import "UIImageView+WebCache.h"

@interface PictoralCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentview1;
@property (weak, nonatomic) IBOutlet UIImageView *Imageview;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIView *contentview2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel2;

@property (weak, nonatomic) IBOutlet UIView *contentview3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel3;

@property (weak, nonatomic) IBOutlet UIView *contentview4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel4;

@property (weak, nonatomic) IBOutlet UIView *contentview5;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel5;

@property (weak, nonatomic) IBOutlet UIView *contentview6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel6;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel6;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *authorArray;
@property (nonatomic, strong) NSArray *contentViewArray;

@property (nonatomic, strong) NSMutableArray *picArray;

@end

@implementation PictoralCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label1.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    
}

- (NSMutableArray *)picArray
{
    if (_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
    
}

- (void)setArticleArray:(NSMutableArray *)articleArray
{
    _articleArray = articleArray;
    
    // 将有图片的文章排在前面(冒泡排序)
    for (int i = 0; i < articleArray.count; i++) {
        for (int j = 0; j < articleArray.count - 1 - i; j++) {
            if (![(PictoralModel *)articleArray[j] thumbnail_pic]) {
                PictoralModel *model = [[PictoralModel alloc]init];
                model = articleArray[j];
                articleArray[j] = articleArray[j + 1];
                articleArray[j + 1] = model;
            }
        }
    }
    
    
    NSInteger count = articleArray.count;
    UILabel *titleLabel = [[UILabel alloc] init];
//    UILabel *authorLabel = [[UILabel alloc] init];
    UIView *view = [[UIView alloc] init];
    PictoralModel *article =[[PictoralModel alloc]init];
    for (int i = 0; i < count; ++i) {
        article = articleArray[i];
        view = self.contentViewArray[i];
        view.layer.borderWidth = 0.25;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        if (article.title) {
            titleLabel = self.titleArray[i];
            titleLabel.text = article.title;
        }
//        if (article.auther_name) {
//            authorLabel = self.authors[i];
//            //            authorLabel.text = article.auther_name;
//            authorLabel.text = [NSString stringWithFormat:@"%@  %@", article.auther_name, [article.date setupCreatedAt]];
//        }
        if (i == 0) {
            if (article.thumbnail_pic) {
                [self.Imageview sd_setImageWithURL:[NSURL URLWithString:article.thumbnail_pic]];
            }
        }
        else
        {
            
            
            
        }
    
        
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
//    __block PictoralModel *article = [[PictoralModel alloc]init];
//    NSLog(@"%@", self.articleArray);
    [self.contentViewArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
               CGPoint point = [touch locationInView:view];
        if ([view pointInside:point withEvent:event]) {
        PictoralModel *model = self.articleArray[idx];
        PictorDetailViewController *detailVC = [[PictorDetailViewController alloc]init];
        detailVC.model = model;
        [[view navController]pushViewController:detailVC animated:YES];
        }
    }];
    
    
    
    
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        NSArray *titles = @[self.label1, self.titleLabel2, self.titleLabel3, self.titleLabel4, self.titleLabel5, self.titleLabel6];
        _titleArray = titles;
    }
    
    
    return _titleArray;
}

- (NSArray *)authorArray
{
    if (!_authorArray) {
        NSArray *authors = @[self.authorLabel2, self.authorLabel3, self.authorLabel4, self.authorLabel5, self.authorLabel6];
        _authorArray = authors;
    }
    
    return _authorArray;
}

- (NSArray *)contentViewArray
{
    if (!_contentViewArray) {
        NSArray *contentview = @[self.contentview1, self.contentview2, self.contentview3, self.contentview4, self.contentview5, self.contentview6];
        _contentViewArray = contentview;
    }

    return _contentViewArray;
}

@end
