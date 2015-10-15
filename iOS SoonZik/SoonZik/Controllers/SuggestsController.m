//
//  SuggestsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "SuggestsController.h"
#import "User.h"
#import "Crypto.h"
//#import "Suggests.h"

@implementation SuggestsController

+ (NSMutableArray *)getSuggests:(NSString *)type {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@suggestv2?user_id=%i&secureKey=%@&type=%@&limit=%i", API_URL, user.identifier, secureKey, type, 30];
    
    NSLog(@"url: %@", url);
    
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"json SUGGEST: %@", json);
    
    return nil;
}


@end
