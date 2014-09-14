//
//  FacebookConnect.h
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface FacebookConnect : NSObject

typedef enum connexionState : NSUInteger {
    kSuccess,
    kNoNetwork,
    kNoAccount,
    kNoAccess
} connexionState;

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) ACAccount *facebookAccount;
//
@property (strong, nonatomic) NSUserDefaults *prefs;
//
//
@property (nonatomic) int isSuccess;
//
@property (strong, nonatomic) NSString *globalmailID;

- (id)init;

@end
