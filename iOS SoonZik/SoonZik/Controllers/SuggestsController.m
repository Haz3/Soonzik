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

+ (NSMutableArray *)getSuggests {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@suggest?user_id=%i&secureKey=%@", API_URL, user.identifier, secureKey];
    
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"json : %@", json);
    
    return nil;
}


@end
