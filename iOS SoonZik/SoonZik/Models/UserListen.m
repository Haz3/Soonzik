//
//  UserListen.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "UserListen.h"

@implementation UserListen

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] integerValue];
    self.lat = [[json objectForKey:@"latitude"] floatValue];
    self.lng = [[json objectForKey:@"longitude"] floatValue];
    self.date = [json objectForKey:@"when"];
    
    self.user = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    self.music = [[Music alloc] initWithJsonObject:[json objectForKey:@"music"]];
    
    return self;
}

@end
