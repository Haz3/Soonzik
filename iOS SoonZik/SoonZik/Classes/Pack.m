//
//  Pack.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Pack.h"

@implementation Pack

/* @property (nonatomic, assign) int identifier;
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, strong) Genre *genre;
 @property (nonatomic, assign) float price;
 @property (nonatomic, strong) NSArray *listOfAlbums;
 @property (nonatomic, strong) NSArray *listOfComments;*/

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.listOfAlbums = [[NSMutableArray alloc] init];
    NSDictionary *albums = [json objectForKey:@"albums"];
    for (NSDictionary *album in albums) {
        //NSLog(@"%@", album);
        Album *al = [[Album alloc] initWithJsonObject:album];
        [self.listOfAlbums addObject:al];
    }
    
    return self;
}

@end
