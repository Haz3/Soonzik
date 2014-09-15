//
//  UserAnnotation.m
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord username:(NSString *)username track:(NSString *)track artist:(NSString *)artist album:(NSString *)album
{
    self = [super init];
    if (self) {
        //self.title = track;
        //self.subtitle = artist;
        
        self.song = track;
        self.album = album;
        self.artist = artist;
        self.username = username;
        
        self.coordinate = coord;
    }
    
    return self;
}

@end
