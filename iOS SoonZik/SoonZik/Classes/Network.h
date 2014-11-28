//
//  Network.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

@property (strong, nonatomic) NSDictionary *json;

- (NSDictionary *) getJsonWithClassName:(NSString *)className;
- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier;
- (NSDictionary *) getJsonClient:(NSString *)token email:(NSString *)email;

@end
