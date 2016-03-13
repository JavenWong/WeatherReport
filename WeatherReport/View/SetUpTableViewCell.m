//
//  SetUpTableViewCell.m
//  WeatherReport
//
//  Created by JavenWong on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "SetUpTableViewCell.h"

@implementation SetUpTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UISwitch *)choiceSwitch
{
    if (_choiceSwitch == nil) {
        _choiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.size.width - 60, 15, 30, 30)];
        [self.contentView addSubview:_choiceSwitch];
    }
    return _choiceSwitch;
}



@end
