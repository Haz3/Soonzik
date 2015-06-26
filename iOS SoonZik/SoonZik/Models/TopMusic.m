//
//  TopMusic.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TopMusic.h"
#import "User.h"

@implementation TopMusic

- (id)initWithJsonObject:(NSDictionary *)json {
    
    self = [super init];
    
    self.note = [[json objectForKey:@"note"] floatValue];
    self.music = [[Music alloc] initWithJsonObject:[json objectForKey:@"music"]];
    
    return self;
}

+ (TopMusic *)getBestMusicOfArtist:(User *)artist
{
    NSString *url = [NSString stringWithFormat:@"%@users/%i/isartist", API_URL, artist.identifier];
    NSDictionary *json = [Request getRequest:url];
    
    NSDictionary *jsonData = [json objectForKey:@"content"];
    
    NSArray *listOfTopMusics = [jsonData objectForKey:@"topFive"];
    NSDictionary *musicElement = [listOfTopMusics firstObject];
    TopMusic *top = [[TopMusic alloc] initWithJsonObject:musicElement];
    
    return top;
}


@end
