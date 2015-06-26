//
//  Battle.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Battle.h"

@implementation Battle

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    //NSLog(@"json : %@", json);
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.artistOne = [[User alloc] initWithJsonObject:[json objectForKey:@"artist_one"]];
    self.artistTwo = [[User alloc] initWithJsonObject:[json objectForKey:@"artist_two"]];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.beginDate = [dateformat dateFromString:[json objectForKey:@"date_begin"]];
    self.endDate = [dateformat dateFromString:[json objectForKey:@"date_end"]];
    
    return self;
}

@end
