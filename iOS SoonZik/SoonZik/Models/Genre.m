//
//  Genre.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Genre.h"

@implementation Genre

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.name = [json objectForKey:@"style_name"];
    self.color = [json objectForKey:@"color_hexa"];
    
    return self;
}

@end
