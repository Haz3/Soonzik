//
//  Crypto.m
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Crypto.h"

@implementation Crypto

+ (NSString *)getKey:(int)userID {
    NSString *url = [NSString stringWithFormat:@"%@getKey/%i", API_URL, userID];
    NSDictionary *results = [Request getRequest:url];
    NSLog(@"GET KEY : %@", results);
    return [results objectForKey:@"key"];
}

+ (NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end
