//
//  Com.m
//  SoonZik
//
//  Created by Maxime Sauvage on 20/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Com.h"
#import "Request.h"
#import "News.h"
#import "Crypto.h"

@implementation Com

- (id) initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.author = [Factory provideObjectWithClassName:@"User" andIdentifier:[[json objectForKey:@"author_id"] intValue]];
    self.content = [json objectForKey:@"content"];
    self.date = [json objectForKey:@"date"];
    
    return self;
}

+ (NSMutableArray *)getCommentsFromNews:(News *)news {
    NSDictionary *json = [Request getRequest:[NSString stringWithFormat:@"%@news/%i/comments", API_URL, news.identifier]];
    NSMutableArray *listOfComments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in [json objectForKey:@"content"]) {
        [listOfComments addObject:[[Com alloc] initWithJsonObject:dict]];
    }
    
    return listOfComments;
}

+ (BOOL)addComment:(News *)news andComment:(NSString *)content {
    NSString *url, *key, *conca, *secureKey;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@news/addcomment/%i", API_URL, news.identifier];
    
    NSDictionary *dict = [Request postRequest:[NSString stringWithFormat:@"user_id=%i&secureKey=%@&content=%@", user.identifier, secureKey, content] url:url];
    
    if ([[dict objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    
    return false;
}

@end
