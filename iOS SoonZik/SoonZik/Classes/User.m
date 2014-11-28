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
    self.facebook = [json objectForKey:@"facebook"];
    self.twitter = [json objectForKey:@"twitter"];
    self.google = [json objectForKey:@"googlePlus"];
    self.idAPI = [json objectForKey:@"idAPI"];
    self.follows = [[NSArray alloc] init];
    self.friends = [[NSArray alloc] init];
    self.address = [[Address alloc] initWithJsonObject:[json objectForKey:@"address"]];
    //self.isAnArtist = [json objectForKey:@"twitter"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.identifier] forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.firstname forKey:@"firstname"];
    [aCoder encodeObject:self.lastname forKey:@"lastname"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.phoneNbr forKey:@"phoneNbr"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.facebook forKey:@"facebook"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.google forKey:@"google"];
    [aCoder encodeObject:self.idAPI forKey:@"idAPI"];
    [aCoder encodeObject:self.follows forKey:@"follows"];
    [aCoder encodeObject:self.friends forKey:@"friends"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.firstname = [aDecoder decodeObjectForKey:@"firstname"];
        self.lastname = [aDecoder decodeObjectForKey:@"lastname"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.phoneNbr = [aDecoder decodeObjectForKey:@"phoneNbr"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.facebook = [aDecoder decodeObjectForKey:@"facebook"];
        self.twitter = [aDecoder decodeObjectForKey:@"twitter"];
        self.google = [aDecoder decodeObjectForKey:@"google"];
        self.idAPI = [aDecoder decodeObjectForKey:@"idAPI"];
        self.follows = [aDecoder decodeObjectForKey:@"follows"];
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
    }
    return self;
}


@end
