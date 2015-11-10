//
//  Pack.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Pack.h"
#import "Description.h"

@implementation Pack

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    NSLog(@"%@", json);
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.listOfAlbums = [[NSMutableArray alloc] init];
    
    NSDictionary *albums = [json objectForKey:@"albums"];
    for (NSDictionary *album in albums) {
        Album *al = [[Album alloc] initWithJsonObject:album];
        [self.listOfAlbums addObject:al];
    }
    
    self.listOfDescriptions = [[NSMutableArray alloc] init];
    NSArray *descriptions = [json objectForKey:@"descriptions"];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"en"]) {
        for (NSDictionary *dict in descriptions) {
            if ([[dict objectForKey:@"language"] isEqualToString:@"EN"]) {
                Description *desc = [[Description alloc] initWithJsonObject:dict];
                [self.listOfDescriptions addObject:desc];
            }
        }
    } else if ([language isEqualToString:@"fr"]) {
        for (NSDictionary *dict in descriptions) {
            if ([[dict objectForKey:@"language"] isEqualToString:@"FR"]) {
                Description *desc = [[Description alloc] initWithJsonObject:dict];
                [self.listOfDescriptions addObject:desc];
            }
        }
    }
    
    self.avgPrice = [[json objectForKey:@"averagePrice"] floatValue];
    
    /*self.partialAlbums = [[NSMutableArray alloc] init];
    NSLog(@"%@", [json objectForKey:@"partial_albums"]);
    NSArray *partial = [json objectForKey:@"partial_albums"];
    for (NSDictionary *dic in partial) {
        [self.partialAlbums addObject:[dic objectForKey:@"album_id"]];
    }*/
    
    return self;
}

+ (Pack *)getPack:(int)packID {
    NSString *url = [NSString stringWithFormat:@"%@packs/%i", API_URL, packID];
    NSDictionary *json = [Request getRequest:url];
    NSDictionary *dict = [json objectForKey:@"content"];
    
    Pack *pack = [[Pack alloc] initWithJsonObject:dict];
    
    return pack;
}

@end
