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
#import "SocialConnect.h"
//#import "GPPURLHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.thePlayer = [[AudioPlayer alloc] init];
    self.thePlayer.index = 0;
    self.thePlayer.oldIndex = 0;
    self.thePlayer.repeatingLevel = 0;
    self.thePlayer.listeningList = [[NSMutableArray alloc] init];
    
    [[UINavigationBar appearance] setTintColor:BLUE_2];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.prefs = [NSUserDefaults standardUserDefaults];
    
    UIViewController *vc;
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    //vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //MenuViewController *mainVC = [[MenuViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *u, NSError *error) {
            if (!error) {
                NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
                User *user = [SocialConnect facebookConnect:token email:[u objectForKey:@"email"]];
                self.prefs = [NSUserDefaults standardUserDefaults];
                [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"User"];
                [self.prefs synchronize];

                HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                
                self.window.rootViewController = nav;
                [self.window makeKeyAndVisible];

            }
        }];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Session closed");
    }
    
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            NSLog(@"%@ => %@", alertTitle, alertText);
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                NSLog(@"%@ => %@", alertTitle, alertText);
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                NSLog(@"%@ => %@", alertTitle, alertText);
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
        NSLog(@"Not logged");
    }
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        NSLog(@"remove control");
        NSLog(@"event : %li", receivedEvent.subtype);
        switch (receivedEvent.subtype) {
            case 101:
            {
                // pause / play
                if (self.thePlayer.audioPlayer.isPlaying) {
                    [self.thePlayer pauseSound];
                } else {
                    [self.thePlayer playSound];
                }
                
            }
            break;
                
                /*case UIEventSubtypeRemoteControlPreviousTrack:
                 [self previousTrack: nil];
                 break;
                 
                 case UIEventSubtypeRemoteControlNextTrack:
                 [self nextTrack: nil];
                 break;
                 */
            default:
                break;
        }
    }
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
    [application beginReceivingRemoteControlEvents];
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
    [FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url = %@", url);
    NSLog(@"source application = %@", sourceApplication);
    NSLog(@"type : %i", self.type);
    
    if (self.type == 1)
    {
        [FBSession.activeSession setStateChangeHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    //return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)setTypeConnexion:(int)type
{
    NSLog(@"change type");
    self.type = type;
}


@end
