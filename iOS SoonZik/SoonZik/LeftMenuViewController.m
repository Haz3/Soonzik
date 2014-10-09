//
//  LeftMenuViewController.m
//  RoomForDay
//
//  Created by Maxime Sauvage on 23/09/2014.
//  Copyright (c) 2014 ok. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "WishlistViewController.h"
#import "ProfileViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tabledata = [@[@"Trouver un Hôtel", @"Mon compte", @"Ma wishlist", @"Mes réservations"] mutableCopy];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabledata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [self.tabledata objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // open VC's
    UINavigationController *nav;
    UIViewController *rootVC;
    switch (indexPath.row) {
        case 1:
            rootVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            break;
        case 0:
            rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            break;
        case 2:
            rootVC = [[WishlistViewController alloc] initWithNibName:@"WishlistViewController" bundle:nil];
            break;
        default:
            break;
    }
    
    nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self openContentNavigationController:nav];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
