//
//  SetUpTableViewController.m
//  WeatherReport
//
//  Created by JavenWong on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "SetUpTableViewController.h"
#import "SetUpTableViewCell.h"
#import "BackgroundAnimationViewController.h"

@interface SetUpTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation SetUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr1 = @[@"账号设置"];
    NSArray *arr2 = @[@"背景动画", @"背景预览"];
    NSArray *arr3 = @[@"自动更新天气", @"自动分享天气", @"GPS定位"];
    NSArray *arr4 = @[@"清除缓存"];
    self.dataArr = [NSMutableArray arrayWithObjects:arr1, arr2, arr3, arr4, nil];
    
    self.navigationItem.title = @"设置";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.rowHeight = 60;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * 7 + 4 * 20, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
    view.backgroundColor = [UIColor colorWithRed:248.0 / 256 green:248.0 / 256 blue:248.0 / 256 alpha:1];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)closeAnimation:(UISwitch *)closeSwith {
//    closeSwith.on = !closeSwith.on;
    if (closeSwith.on == YES) {
        NSLog(@"1");
        NSString *didCloseAnimation = @"1";
        [[NSUserDefaults standardUserDefaults] setObject:didCloseAnimation forKey:@"didCloseAnimation"];
    } else {
        NSLog(@"0");
        NSString *didCLoseAnimation = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:didCLoseAnimation forKey:@"didCloseAnimation"];
    }
}

- (void)clearStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"default"];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0 || indexPath.row == 2) && (indexPath.section == 1 || indexPath.section == 2)) {
        [self.tableView registerNib:[UINib nibWithNibName:@"SetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
        SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
        cell.choiceSwitch.on = YES;
        NSArray *arr = self.dataArr[indexPath.section];
        cell.DataLb.text = arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1 && indexPath.item == 0) {
            [cell.choiceSwitch addTarget:self action:@selector(closeAnimation:) forControlEvents:UIControlEventValueChanged];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"] isEqualToString:@"0"]) {
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"didCloseAnimation"]);
                cell.choiceSwitch.on = NO;
            } else {
                cell.choiceSwitch.on = YES;
            }
            
        }
        return cell;
    }
    else {
        [self.tableView registerNib:[UINib nibWithNibName:@"SetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse2"];
        SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse2" forIndexPath:indexPath];
//        cell.choiceSwitch.on = YES;
        NSArray *arr = self.dataArr[indexPath.section];
        cell.DataLb.text = arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 3) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            path = [path stringByAppendingPathComponent:@"default"];
            float fileSize = [self folderSizeAtPath:path];
            cell.fileSizeLb.text = [NSString stringWithFormat:@"(%.2f M)", fileSize];
            
        }
        
        return cell;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 20;
    }
    else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        [self clearStore];
        [self.tableView reloadData];
    } else if (indexPath.section == 1 && indexPath.item == 1) {
        BackgroundAnimationViewController *vc = [[BackgroundAnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
