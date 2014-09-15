//
//  Network.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Network.h"

@implementation Network

- (NSDictionary *) getJsonWithClassName:className
{
    NSString *path = nil;
    
    if ([className isEqualToString:@"user"])
        path = @"/api/user";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    
    return self.json;
}

- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier
{
    NSString *path = nil;
    
    if ([className isEqualToString:@"user"])
        path = @"/api/user/identifier";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    
    return self.json;
}

- (void)fetchedData:(NSData *)data
{
    NSError *error;
    self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

@end
