//
//  Factory.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Factory.h"

@implementation Factory

- (id)provideObjectWithClassName:(NSString *)className andIdentifier:(int)identifier
{
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className andIdentifier:identifier];
    
    Element *elem;
    for (NSDictionary *dict in json) {
        elem = [[cl alloc] initWithJsonObject:dict];
    }
    
    return elem;
}

- (NSArray *) provideListWithClassName:(NSString *)className
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className];
    
    for (NSDictionary *dict in json) {
        Element *elem = [[cl alloc] initWithJsonObject:dict];
        [list addObject:elem];
    }
    
    //Element *elem = [[cl alloc] initWithJsonObject:nil];
    //NSLog(@"dans methode");
    return list;
}

- (NSArray *) provideListWithClassName:(NSString *)className andIdentifier:(int)identifier
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className andIdentifier:identifier];
    
    for (NSDictionary *dict in json) {
        Element *elem = [[cl alloc] initWithJsonObject:dict];
        [list addObject:elem];
    }
    
    return list;
}

- (BOOL)addElement:(id)elem
{
    return NO;
}

- (BOOL)deleteElement:(id)elem
{
    return NO;
}

- (BOOL)saveElement:(id)elem
{
    return NO;
}

@end
