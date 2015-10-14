//
//  PacksController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PacksController.h"
#import "User.h"

@implementation PacksController

+ (Pack *)getPack:(int)packID {
    NSString *url = [NSString stringWithFormat:@"%@packs/%i", API_URL, packID];
    NSDictionary *json = [Request getRequest:url];
    
    NSLog(@"%@", [json objectForKey:@"content"]);
    Pack *pack = [[Pack alloc] initWithJsonObject:[json objectForKey:@"content"]];

    return pack;
}

+ (BOOL)buyPack:(int)packID amount:(float)amount artist:(float)artist association:(float)association website:(float)website withPayPalInfos:(PayPalPayment *) paymentInfos {
    NSDictionary *payment = paymentInfos.confirmation;
    NSDictionary *paymentResponse = [payment objectForKey:@"response"];
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@purchase/buypack", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&pack_id=%i&amount=%f&artist=%f&association=%f&website=%f&paypal[payment_id]=%@", user.identifier, secureKey, packID, amount, artist, association, website, [paymentResponse objectForKey:@"id"]];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json payment : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    return false;

}

@end
