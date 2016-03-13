//
//  UIViewController+HUD.h
//  MusicPlayer
//
//  Created by 黄红荫 on 16/1/22.
//  Copyright © 2016年 黄红荫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)

-(void)showHUD:(NSString*)str;
-(void)hideHUD;
-(void)showHUDWithMBProgressHUD:(MBProgressHUD*)hud str:(NSString *)str;
-(void)hideHUDWithMBProgressHUD:(MBProgressHUD*)hud timer:(NSInteger)timer
;
@end
