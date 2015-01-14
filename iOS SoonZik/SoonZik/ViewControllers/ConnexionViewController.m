//
//  ConnexionViewController.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ConnexionViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>

/*#import "GTLPlusConstants.h"
#import "GTLQueryPlus.h"
#import "GTMLogger.h"
#import "GTLPlusPerson.h"
#import "GTLServicePlus.h"
#import "GTMOAuth2Authentication.h"*/

@interface ConnexionViewController ()

@end

@implementation ConnexionViewController

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
    
    [self initializeButtons];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.view.frame.size.height / 2, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    self.emailConnexionArea.alpha = 0.0f;
    
    self.loadingDataIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingDataIndicator.center = CGPointMake(160, self.view.frame.size.height-100);
    self.loadingDataIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingDataIndicator];
}

- (void)initializeButtons
{
    [self.facebookButton addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.googleButton addTarget:self action:@selector(loginWithGoogle) forControlEvents:UIControlEventTouchUpInside];
    [self.twitterButton addTarget:self action:@selector(loginWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton addTarget:self action:@selector(loginWithEmail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginWithFacebook
{
    AppDelegate *delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate setTypeConnexion:1];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)loginWithTwitter
{

}

/*- (void)loginWithGoogle
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = @"86194997201-a8usvamk2efjomucfg1b99i02332gsj5.apps.googleusercontent.com";
    signIn.scopes = [NSArray arrayWithObjects:
                     @"https://www.googleapis.com/auth/plus.login",
                     @"https://www.googleapis.com/auth/userinfo.email",
                     @"https://www.googleapis.com/auth/userinfo.profile", // Défini dans GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    
    [signIn authenticate];
}*/

- (void)loginWithEmail
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.soonzikLogo.frame.size.height + 30, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.emailConnexionArea setAlpha:1.0f];
    } completion:nil];
    
}

- (void)launchHomePage {
    NSLog(@"Lancement de la page d'accueil");
    
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
    GOOGLE CONNECT
 **/

/*
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    /*self.kindOfProvider = 1;
    NSLog(@"ID Token: %@", auth.accessToken);
    
    [self getJsonClient:auth.accessToken provider:@"google"];
    self.prefs = [NSUserDefaults standardUserDefaults];
    [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:self.client] forKey:@"Client"];
    [self.prefs synchronize];
    
    MenuViewController *mainVC = [[MenuViewController alloc] init];
    [self.navigationController initWithRootViewController:mainVC];*/
/*}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // L'utilisateur est connecté.
        self.googleButton.hidden = YES;
        // Effectuer d'autres actions ici, comme afficher un bouton de déconnexion, par exemple
    } else {
        self.googleButton.hidden = NO;
        // Effectuer d'autres actions ici
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // L'utilisateur est déconnecté et l'application dissociée de Google+.
        // Effacer les données de l'utilisateur conformément aux conditions d'utilisation de la Plate-forme Google+.
    }
}*/

@end
