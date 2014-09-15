//
//  ConnexionViewController.h
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ConnexionViewController : UIViewController 

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (assign, nonatomic) bool isFacebookAvailable;

@property (strong, nonatomic) NSString *fbID, *globalFBID;

@property (nonatomic, strong) NSUserDefaults *prefs;

@property (strong, nonatomic) UIActivityIndicatorView *loadingDataIndicator;

@property (weak, nonatomic) IBOutlet UIView *kindOfConnexionArea;
@property (weak, nonatomic) IBOutlet UIView *emailConnexionArea;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UIImageView *soonzikLogo;
@end
