//
//  ZKRArticleDetailTopView.m
//  Zaker-C
//
//  Created by GuangliChan on 16/3/2.
//  Copyright © 2016年 GLChen. All rights reserved.
//

#import "ZKRArticleDetailTopView.h"
#import "PictoralModel.h"

@interface ZKRArticleDetailTopView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation ZKRArticleDetailTopView

- (void)setItem:(PictoralModel *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    self.authorLabel.text = item.auther_name;
    self.backgroundColor = [UIColor blackColor];
}
@end
