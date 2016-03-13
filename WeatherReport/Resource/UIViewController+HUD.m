//
//  UIViewController+HUD.m
//  MusicPlayer
//
//  Created by 黄红荫 on 16/1/22.
//  Copyright © 2016年 黄红荫. All rights reserved.
//

#import "UIViewController+HUD.h"
@implementation UIViewController (HUD)
-(void)showHUD:(NSString*)str
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithFrame:self.view.bounds];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = str;
    hud.tag = 1000;
    [hud show:YES];
    [self.view addSubview:hud];

}

-(void)hideHUD
{
    MBProgressHUD *hud = (MBProgressHUD*)[self.view viewWithTag:1000];
    [hud hide:YES afterDelay:1];
    
}


-(void)showHUDWithMBProgressHUD:(MBProgressHUD*)hud str:(NSString *)str
{
  
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = str ;
    hud.tag = 1000;
    [hud show:YES];
    [self.view addSubview:hud];

}
-(void)hideHUDWithMBProgressHUD:(MBProgressHUD*)hud timer:(NSInteger)timer
{
    [hud hide:YES afterDelay:timer];

}

@end
