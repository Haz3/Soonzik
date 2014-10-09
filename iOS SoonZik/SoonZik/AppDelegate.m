//
//  AppDelegate.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstLaunchViewController.h"
#import "ConnexionViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[UIBarButtonItem appearance].tintColor = [UIColor blackColor];
    
    self.thePlayer = [[AudioPlayer alloc] init];
    //self.thePlayer.audioPlayer = [[AVAudioPlayer alloc] initWithData:nil error:nil];
    self.thePlayer.index = 0;
    self.thePlayer.oldIndex = 0;
    self.thePlayer.repeatingLevel = 0;
    self.thePlayer.listeningList = [[NSMutableArray alloc] init];
        
    self.prefs = [NSUserDefaults standardUserDefaults];
    
    UIViewController *vc;
    
   /* if ([self.prefs integerForKey:@"isNotTheFirstUse"] == 0) {
        NSLog(@"It's the first use");
        [self.prefs setInteger:1 forKey:@"isNotTheFirstUse"];
        [self.prefs setInteger:0 forKey:@"autoLogin"];
        [self.prefs synchronize];
        
        vc = [[FirstLaunchViewController alloc] initWithNibName:@"FirstLaunchViewController" bundle:nil];
    } else if ([self.prefs integerForKey:@"autoLogin"] == 1){
        NSLog(@"User choose auto-login method");
        vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    } else {
        NSLog(@"It's not the first use");
        vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    } */
    
    vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //MenuViewController *mainVC = [[MenuViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    
}




@end
