//
//  Album.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Album.h"

@implementation Album

/*
 @property (nonatomic, assign) int identifier;
 @property (strong, nonatomic) NSString *title;
 @property (strong, nonatomic) User *artist;
 @property (strong, nonatomic) NSString *image;
 @property (strong, nonatomic) NSDate *date;
 */

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.image = [json objectForKey:@"file"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.title = [json objectForKey:@"title"];
    self.listOfMusics = [[NSMutableArray alloc] init];
    NSDictionary *musics = [json objectForKey:@"musics"];
    NSLog(@"m : %@", musics);
    if (musics != nil) {
        for (NSDictionary *music in musics) {
            //NSLog(@"%@", album);
            Music *m = [[Music alloc] initWithJsonObject:music];
            m.image = self.image;
            [self.listOfMusics addObject:m];
        }
    }
    
    return self;
}

@end
