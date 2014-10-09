//
//  MenuViewController.m
//  RoomForDay
//
//  Created by Maxime Sauvage on 18/09/2014.
//  Copyright (c) 2014 ok. All rights reserved.
//

#import "MenuViewController.h"
#import "LeftMenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    /*******************************
     *     Initializing menus
     *******************************/
    self.leftMenu = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    //self.rightMenu = [[RightMenuTVC alloc] initWithNibName:@"RightMenuTVC" bundle:nil];
    /*******************************
     *     End Initializing menus
     *******************************/
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0, 0};
    frame.size = (CGSize){24, 24};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
}

/*- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu.png"] forState:UIControlStateNormal];
}*/

- (BOOL)deepnessForLeftMenu
{
    return YES;
}

- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
