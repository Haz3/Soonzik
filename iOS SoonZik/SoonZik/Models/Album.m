//
//  Album.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.image = [json objectForKey:@"image"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.title = [json objectForKey:@"title"];
    if ([json objectForKey:@"user"]) {
        self.artist = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    }
    self.listOfMusics = [[NSMutableArray alloc] init];
    NSDictionary *musics = [json objectForKey:@"musics"];
    
    if (musics != nil) {
        int i = 0;
        for (NSDictionary *music in musics) {
            Music *m = [[Music alloc] initWithJsonObject:music];
            m.image = self.image;
            Album *album = [[Album alloc] init];
            album.identifier = self.identifier;
            album.image = self.image;
            album.price = self.price;
            album.title = self.title;
            album.artist = self.artist;
            m.album = [[NSMutableArray alloc] init];
            [m.album addObject:album];
            [self.listOfMusics addObject:m];
            i++;
        }
    }
    
    return self;
}

@end
