//
//  BattlesController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "BattlesController.h"

@implementation BattlesController

+ (NSMutableArray *)getAllTheBattles {
    NSString *url = [NSString stringWithFormat:@"%@battles", API_URL];
    NSDictionary *json = [Request getRequest:url];
    NSArray *content = [json objectForKey:@"content"];
    NSLog(@"content size : %i", content.count);
    NSMutableArray *listOfBattles = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in content) {
        Battle *battle = [[Battle alloc] initWithJsonObject:dict];
        [listOfBattles addObject:battle];
    }
    
    return listOfBattles;
}

+ (Battle *)getBattle:(int)battleID {
    Battle *battle = [[Battle alloc] init];
    
    return battle;
}

+ (Battle *)vote:(int)battleID :(int)artistID {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@battles/%i/vote", API_URL, battleID];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&artist_id=%i", user.identifier, secureKey, artistID];
    
    NSLog(@"url : %@", url);
    NSLog(@"post : %@", post);
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"vote json : %@", json);
    if ([[json objectForKey:@"code"] intValue] != 200) {
        return nil;
    }
    
    NSDictionary *content = [json objectForKey:@"content"];
    return [[Battle alloc] initWithJsonObject:content];
}


@end
