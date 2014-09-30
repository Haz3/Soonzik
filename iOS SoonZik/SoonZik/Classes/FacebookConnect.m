//
//  FacebookConnect.m
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "FacebookConnect.h"

#define FACEBOOK_KEY @"1430876857180196"

@implementation FacebookConnect

- (id)init
{
    self = [super init];
    
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *fbAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = FACEBOOK_KEY;
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key, ACFacebookAppIdKey, @[@"email"], ACFacebookPermissionsKey, nil];
    
    [self.accountStore requestAccessToAccountsWithType:fbAccountType options:dictFB completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:fbAccountType];
            self.facebookAccount = [accounts lastObject];
            
            ACAccountCredential *facebookCredential = [self.facebookAccount credential];
            NSString *accessToken = [facebookCredential oauthToken];
            NSLog(@"Facebook Access Token: %@", accessToken);
            
            NSLog(@"Facebook Account: %@", self.facebookAccount);
            
            [self get];
            
        } else {
            NSLog(@"permission denied: %@", error);
            self.isSuccess = kNoAccount;
        }
    }];
    
    return self;
}


-(void)get
{
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        
        if(!error)
        {
            
            NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            NSLog(@"Dictionary contains: %@", list );
            
            NSString *globalmailID   = [NSString stringWithFormat:@"%@",[list objectForKey:@"email"]];
            NSLog(@"global mail ID : %@",globalmailID);
            
            self.prefs = [NSUserDefaults standardUserDefaults];
            [self.prefs setInteger:1 forKey:@"autoLogin"];
            [self.prefs synchronize];
            
            if([list objectForKey:@"error"]!=nil)
            {
                [self attemptRenewCredentials];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                
            });
            self.isSuccess = kSuccess;
        }
        else
        {
            //handle error gracefully
            NSLog(@"error from get%@",error);
            //attempt to revalidate credentials
            self.isSuccess = kNoNetwork;
        }
        
        
    }];
    
}


-(void)accountChanged:(NSNotification *)notification
{
    [self attemptRenewCredentials];
}

-(void)attemptRenewCredentials
{
    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
        if(!error)
        {
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    NSLog(@"Good to go");
                    [self get];
                    break;
                case ACAccountCredentialRenewResultRejected:
                    NSLog(@"User declined permission");
                    break;
                case ACAccountCredentialRenewResultFailed:
                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
                    break;
                default:
                    break;
            }
            
        }
        else{
            //handle error gracefully
            NSLog(@"error from renew credentials%@",error);
            self.isSuccess = kNoAccess;
        }
    }];
}

@end
