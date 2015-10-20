//
//  TweetsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TweetsController.h"
#import "Tweet.h"
#import "User.h"

@implementation TweetsController

+ (BOOL)sendTweet:(NSString *)message {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@tweets/save", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&tweet[user_id]=%i&tweet[msg]=%@", user.identifier, secureKey, user.identifier, message];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json tweet envoi : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    
    return false;
}

+ (NSMutableArray *)getTweets:(int)userId {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    url = [NSString stringWithFormat:@"%@tweets/find?attribute[user_id]=%i", API_URL, userId];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"json tweet : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 200) {
        for (NSDictionary *dict in [json objectForKey:@"content"]) {
            [arr addObject:[[Tweet alloc] initWithJsonObject:dict]];
        }
    }
    
    return arr;
}

@end