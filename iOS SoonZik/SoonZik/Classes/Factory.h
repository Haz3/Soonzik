//
//  Factory.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"
#import "Network.h"

@interface Factory : NSObject

- (id)provideObjectWithClassName:(NSString *)className andIdentifier:(int)identifier;
- (NSArray *)provideListWithClassName:(NSString *)className;

- (BOOL)addElement:(id)elem;
- (BOOL)deleteElement:(id)elem;
- (BOOL)saveElement:(id)elem;

@end
