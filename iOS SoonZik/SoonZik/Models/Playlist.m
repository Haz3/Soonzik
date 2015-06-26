//
//  Playlist.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Playlist.h"
#import "Music.h"

@implementation Playlist

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"name"];
    NSDictionary *musics = [json objectForKey:@"musics"];
    self.listOfMusics = [[NSMutableArray alloc] init];
    if (musics != nil) {
        int i = 0;
        for (NSDictionary *music in musics) {
            Music *m = [[Music alloc] initWithJsonObject:music];
            [self.listOfMusics addObject:m];
            i++;
        }
    }
    
    return self;
}

+ (Playlist *)createAPlaylist:(Playlist *)playlist {
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net create:playlist];
    
    Playlist *p;
    if ([[json objectForKey:@"code"] intValue] != 503) {
        p = [[Playlist alloc] initWithJsonObject:[json objectForKey:@"content"]];
    } else {
        p = [[Playlist alloc] init];
        p.identifier = -1;
    }
    return p;
}

@end
