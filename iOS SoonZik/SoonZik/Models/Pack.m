//
//  Pack.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Pack.h"

@implementation Pack

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.listOfAlbums = [[NSMutableArray alloc] init];
    
    NSDictionary *albums = [json objectForKey:@"albums"];
    for (NSDictionary *album in albums) {
        Album *al = [[Album alloc] initWithJsonObject:album];
        [self.listOfAlbums addObject:al];
    }
    
    return self;
}

@end
