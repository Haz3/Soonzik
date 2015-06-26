//
//  SocialConnect.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Connexion.h"
#import "User.h"

@interface SocialConnect : Connexion

- (User *)facebookConnect:(NSString *)token email:(NSString *)email uid:(NSString *)uid;
- (User *)twitterConnect:(NSString *)token email:(NSString *)email uid:(NSString *)uid;
- (User *)googleConnect:(NSString *)token email:(NSString *)email uid:(NSString *)uid;

+ (BOOL)shareOnFacebook:(id)elem onVC:(UIViewController *)vc;
+ (BOOL)shareOnTwitter:(id)elem onVC:(UIViewController *)vc;

@end
