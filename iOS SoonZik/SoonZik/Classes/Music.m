//
//  Music.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Music.h"

@implementation Music

/*
 @property (nonatomic, assign) int identifier;
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, assign) int duration;
 @property (nonatomic, strong) Genre *genre;
 @property (nonatomic, assign) float price;
 @property (nonatomic, strong) NSString *file;
 @property (nonatomic, strong) User *artist;
 @property (nonatomic, strong) NSString *image;
 //@property (nonatomic, strong) Album *album;
 @property (nonatomic, strong) NSArray *listOfComments;
 */

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.duration = [[json objectForKey:@"duration"] intValue];
    self.file = [json objectForKey:@"file"];
    self.isLimited = [[json objectForKey:@"limited"] intValue];
    self.price = [[json objectForKey:@"price"] floatValue];
    
    //self.artist = [[json objectForKey:@"user_id"] intValue];
    
    return self;
}

@end
