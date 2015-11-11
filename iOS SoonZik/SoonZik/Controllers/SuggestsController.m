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
    
    key = [Crypto getKey];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@suggestv2?type=%@&limit=%i", API_URL, type, 30];
    
    NSLog(@"url: %@", url);
    
    NSDictionary *json = [Request getRequest:url];
    NSDictionary *content = [json objectForKey:@"content"];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (NSDictionary *u in content) {
        User *user = [[User alloc] initWithJsonObject:u];
        [list addObject:user];
    }
    
    return list;
}


@end
