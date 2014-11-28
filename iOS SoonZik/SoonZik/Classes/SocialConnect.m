//
//  SocialConnect.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "SocialConnect.h"
#import "Network.h"
#import "User.h"

@implementation SocialConnect

+ (User *)facebookConnect:(NSString *)token email:(NSString *)email
{
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonClient:token email:email];
    
    json = [json objectForKey:@"content"];
    User *elem = [[User alloc] initWithJsonObject:json];
    
    return elem;
}

+ (void)twitterConnect
{
    
}

+ (void)googleConnect
{
    
}

@end
