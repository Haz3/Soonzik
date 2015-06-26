//
//  Suggest.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Suggest.h"
#import "User.h"
#import "Crypto.h"
#import "Request.h"

@implementation Suggest

- (id)initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    NSLog(@"%@", json);
    
    return self;
}


+ (Suggest *)getAllSuggests {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    
    url = [NSString stringWithFormat:@"%@suggest?user_id=%i&secureKey=%@", API_URL, user.identifier, secureKey];
    NSLog(@"url : %@", url);
    NSDictionary *json = [Request getRequest:url];
    
    if ([[json objectForKey:@"code"] intValue] == 200) {
        return [[Suggest alloc] initWithJsonObject:[json objectForKey:@"content"]];
    }
    
    return nil;
}

@end
