//
//  CityTableViewController.m
//  WeatherReport
//
//  Created by JavenWong on 16/2/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "CityTableViewController.h"
#import "AddCityViewController.h"
#import "CityTableViewCell.h"

@interface CityTableViewController ()


@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(turnToAddCityPage:)];
    
    UIBarButtonItem *editBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem, editBarButtonItem];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)turnToAddCityPage:(UIBarButtonItem *)barButtonItem
{
    AddCityViewController *vc = [[AddCityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// editing
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *cityNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
    // must create a new mutablearr or it will be crash
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:cityNameArr];
    [mutableArr removeObjectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableArr forKey:@"cityNameArr"];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    CityTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *cityName = cell.CityNameLb.text;
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"cityName"];
//    self.changeCityNameBlock(cityName);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *cityNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
    return cityNameArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CityTableViewCell alloc] init];
    }
    // Configure the cell...
    NSMutableArray *cityNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNameArr"];
    cell.CityNameLb.text = cityNameArr[indexPath.row];
    
    NSString *tmpMaxStr = [NSString stringWithFormat:@"%@TmpMax", cell.CityNameLb.text];
    NSString *tmpMax = [[NSUserDefaults standardUserDefaults] objectForKey:tmpMaxStr];
    cell.maxTmpLb.text = [NSString stringWithFormat:@"%@°C", tmpMax];
    
    NSString *tmpMinStr = [NSString stringWithFormat:@"%@TmpMin", cell.CityNameLb.text];
    NSString *tmpMin = [[NSUserDefaults standardUserDefaults] objectForKey:tmpMinStr];
    cell.minTmpLb.text = [NSString stringWithFormat:@"%@°C", tmpMin];
    
    return cell;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
