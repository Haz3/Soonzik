//
//  EmailConnect.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "EmailConnect.h"
#import "Network.h"

@implementation EmailConnect

- (User *)emailConnect:(NSString *)email andPassword:(NSString *)password
{
    NSDictionary *net = [[Network alloc] getJsonClient:email andPassword:password];
    User *user = [[User alloc] initWithJsonObject:[net objectForKey:@"content"]];
    
    return user;
}

@end
