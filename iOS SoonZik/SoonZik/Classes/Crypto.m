//
//  Crypto.m
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Crypto.h"
#import "User.h"

@implementation Crypto

+ (NSString *)getKey {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    bool need = false;
    
    NSLog(@"user.secureKey : %@", user.secureKey);
    if (user.secureKey == nil) {    // if secureKey is null
        need = true;
        NSLog(@"secure KEy is null");
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSDate *dat = [dateFormat dateFromString:user.secureKeyDate];
        NSTimeInterval secondsInOneHours = 60 * 60;
        NSDate *dateOneHoursAhead = [dat dateByAddingTimeInterval:secondsInOneHours];
        
        NSLog(@"user.secureDate : %@", dateOneHoursAhead);
        
        switch ([dateOneHoursAhead compare:[NSDate date]]) {
            case NSOrderedAscending:
                NSLog(@"NSOrderedAscending");
                need = true;
                break;
            case NSOrderedSame:
                NSLog(@"NSOrderedSame");
                need = true;
                break;
            case NSOrderedDescending:
                NSLog(@"NSOrderedDescending");
                break;
        }

    }
    
    if (need) {
        
        NSLog(@"NEED");
        
        NSString *url = [NSString stringWithFormat:@"%@getKey/%i", API_URL, user.identifier];
        NSDictionary *json = [Request getRequest:url];
        
        NSString *stringDate = [json objectForKey:@"last_update"];
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];
        
        NSString *secureKey = [json objectForKey:@"key"];
        
        NSString *conca = [NSString stringWithFormat:@"%@%@", user.salt, secureKey];
        NSString *key = [Crypto sha256HashFor:conca];
        
        user.secureKeyDate = stringDate;
        user.secureKey = key;
        
        NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        NSLog(@"NO NEED");
    }
    
    return user.secureKey;
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
