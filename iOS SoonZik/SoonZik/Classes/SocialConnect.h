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

+ (User *)facebookConnect:(NSString *)token email:(NSString *)email;
+ (void)twitterConnect;
+ (void)googleConnect;

@end
