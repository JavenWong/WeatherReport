//
//  PictoralCollectionViewCell.h
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictoralModel.h"


typedef void(^Blocker)(void);

@interface PictoralCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray *articleArray;


@property (nonatomic, strong) PictoralModel *pictoralModel;

@property (nonatomic, copy) Blocker block;

@end
