//
//  ConnexionViewController.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ConnexionViewController.h"
#import "HomeViewController.h"
#import "FacebookConnect.h"
#import "AppDelegate.h"

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
    [self.twitterButton addTarget:self action:@selector(loginWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton addTarget:self action:@selector(loginWithEmail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginWithFacebook
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.emailConnexionArea setAlpha:0.0f];
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.view.frame.size.height / 2, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    } completion:nil];

    FacebookConnect *fb = [[FacebookConnect alloc] init];
    NSLog(@"chargement");

    sleep(2);
    NSLog(@"FacebookIsAvailable: %d", fb.isSuccess);
    if (fb.isSuccess == kSuccess) {
        [self launchHomePage];
    } else if (fb.isSuccess == kNoAccount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez ajouter un compte Facebook dans vos paramètres iOS afin d'accèder à la connexion via Facebook" delegate:self cancelButtonTitle:@"D'accord" otherButtonTitles:nil, nil];
        [alert show];
    } else if (fb.isSuccess == kNoAccess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez accepter les conditions de partage Facebook" delegate:self cancelButtonTitle:@"D'accord" otherButtonTitles:nil, nil];
        [alert show];
    } else if (fb.isSuccess == kNoNetwork) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez vous connecter à un réseau pour accéder à l'application" delegate:self cancelButtonTitle:@"D'accord" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.loadingDataIndicator startAnimating];
    [self.loadingDataIndicator stopAnimating];
}

- (void)launchHomePage {
    NSLog(@"Lancement de la page d'accueil");
    
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginWithTwitter
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.emailConnexionArea setAlpha:0.0f];
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.view.frame.size.height / 2, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    } completion:nil];
    
    [self.loadingDataIndicator startAnimating];
}

- (void)loginWithEmail
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.soonzikLogo.frame.size.height + 30, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.emailConnexionArea setAlpha:1.0f];
    } completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
