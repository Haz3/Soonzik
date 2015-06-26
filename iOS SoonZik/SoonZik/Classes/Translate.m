//
//  Translate.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Translate.h"

@implementation Translate

+ (id)sharedInstance {
    static Translate *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)initWithPath:(NSString *)path {
    self = [super init];
    self.dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    int number = [[[[self.dict objectForKey:@"One"] objectForKey:@"Two"]objectForKey:@"Three"] intValue];
    NSLog(@"%d",number);
    
    return self;
}

@end
