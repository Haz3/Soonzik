//
//  User.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "User.h"
#import "Address.h"

@implementation User

- (id)initWithJsonObject:(NSDictionary *)json
{
    NSLog(@"USER");
    
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.email = [json objectForKey:@"email"];
    self.username = [json objectForKey:@"username"];
    self.firstname = [json objectForKey:@"fname"];
    self.lastname = [json objectForKey:@"lname"];
    self.birthday = [json objectForKey:@"birthday"];
    self.image = [json objectForKey:@"image"];
    self.desc = [json objectForKey:@"description"];
    self.phoneNbr = [json objectForKey:@"phoneNumber"];
    self.address = [[Address alloc] init];
    self.facebook = [json objectForKey:@"facebook"];
    self.twitter = [json objectForKey:@"twitter"];
    self.google = [json objectForKey:@"googlePlus"];
    self.idAPI = [json objectForKey:@"idAPI"];
    self.follows = [[NSArray alloc] init];
    self.friends = [[NSArray alloc] init];
    //self.isAnArtist = [json objectForKey:@"twitter"];
    
    return self;
}

@end
