//
//  AppDelegate.h
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AudioPlayer.h"
#import "ConnexionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) AudioPlayer *thePlayer;

@property (strong, nonatomic) ConnexionViewController *connexionViewController;

@property (strong, nonatomic) NSUserDefaults *prefs;

@property (nonatomic) int type;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)setTypeConnexion:(int)type;

@end
