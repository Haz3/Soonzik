//
//  MessagesController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "MessagesController.h"
#import "User.h"
#import "Message.h"
#import "Crypto.h"

@implementation MessagesController

+ (NSMutableArray *)getMessagesWithFriendId:(int)userID withOffset:(int)offset {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@messages/conversation/%i?user_id=%i&secureKey=%@&offset=%i", API_URL, userID, user.identifier, secureKey, offset];
    
    NSDictionary *json = [Request getRequest:url];
    //NSLog(@"json messages : %@", json);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [json objectForKey:@"content"]) {
        [array addObject:[[Message alloc] initWithJsonObject:dic]];
    }

    return array;
}

@end
