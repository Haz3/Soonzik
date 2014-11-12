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
    NSLog(@"PACK");
    
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    //self.genre = []
    
    return self;
}

@end
