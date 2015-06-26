//
//  Network.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Crypto.h"

@interface Network : NSObject

@property (strong, nonatomic) NSDictionary *json;

- (NSDictionary *) getJsonWithClassName:(NSString *)className;
- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier;
- (NSDictionary *)getJsonClient:(NSString *)token email:(NSString *)email uid:(NSString *)uid type:(int)type;
- (NSDictionary *) getJsonClient:(NSString *)email andPassword:(NSString *)password;

- (NSDictionary *) findJsonElementWithClassName:className andValues:(NSString *)values;

- (NSDictionary *)create:(id)elem;
- (NSDictionary *)update:(id)elem;
- (NSDictionary *)destroy:(id)elem;

@end
