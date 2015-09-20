//
//  PacksController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PacksController.h"

@implementation PacksController

+ (Pack *)getPack:(int)packID {
    NSString *url = [NSString stringWithFormat:@"%@packs/%i", API_URL, packID];
    NSDictionary *json = [Request getRequest:url];
    
    NSLog(@"%@", [json objectForKey:@"content"]);
    Pack *pack = [[Pack alloc] initWithJsonObject:[json objectForKey:@"content"]];

    return pack;
}

@end
