//
//  CartController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 08/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "CartController.h"
#import "User.h"

@implementation CartController

+ (NSMutableArray *)getCart {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];

    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@carts/my_cart?user_id=%i&secureKey=%@", API_URL, user.identifier, secureKey];

    NSDictionary *json = [Request getRequest:url];
    NSLog(@"json cart : %@", json);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [json objectForKey:@"content"]) {
        [array addObject:[[Cart alloc] initWithJsonObject:dic]];
    }
    
    return array;
}

+ (Cart *)addToCart:(NSString *)type :(int)objId {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@carts/save", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    // gift_user_id if it is a gift from someone
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&cart[user_id]=%i&cart[typeObj]=%@&cart[obj_id]=%i", user.identifier, secureKey, user.identifier, type, objId];
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json : %@", json);
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return [[Cart alloc] initWithJsonObject:[json objectForKey:@"content"]];
    }
    
    return nil;
}

+ (BOOL)removeCart:(int)cartId {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@carts/destroy?user_id=%i&secureKey=%@&id=%i", API_URL, user.identifier, secureKey, cartId];
    
    NSDictionary *json = [Request getRequest:url];
    
    NSLog(@"%@", json);
    
    if ([[json objectForKey:@"code"] intValue] == 202)
        return true;
    
    return false;
}

+ (NSMutableArray *)giftCart:(int)cartId forUser:(int)userId {
    NSString *url, *key, *conca, *secureKey, *post;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@carts/%i/gift", API_URL, cartId];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&user_gift_id=%i", user.identifier, secureKey, userId];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSLog(@"%@", json);
    for (NSDictionary *dic in [json objectForKey:@"content"]) {
        [array addObject:[[Cart alloc] initWithJsonObject:dic]];
    }
    
    return array;
}

+ (BOOL)buyCart {
    NSString *url, *key, *conca, *secureKey, *post;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@purchases/buycart", API_URL];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@", user.identifier, secureKey];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"%@", json);
    
    if ([[json objectForKey:@"code"] intValue] == 201)
        return true;
    
    return false;
}

@end
