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

+ (NSString *)getKey:(int)userID {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    bool need = false;
    
    if (user.secureKey == nil) {    // if secureKey is null
        need = true;
        NSLog(@"secure KEy is null");
    } else {    // if secureKey is not null
        
        NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:unitFlags fromDate:user.secureKeyDate toDate:[NSDate date] options:0];
        
        NSLog(@"user.getDate : %@", user.secureKeyDate);
        
        NSLog(@"secureKey difference date : %iH:%iM:%iS", [components hour], [components minute], [components second]);
        
        if ([components hour] < 1) {
            NSLog(@"PAS besoin de getkey");
        } else {
            NSLog(@"BESOIN de getkey");
            need = true;
        }
    }
    
    if (need) {
        
        NSLog(@"NEEDEDDDDDD");
        
        NSString *url = [NSString stringWithFormat:@"%@getKey/%i", API_URL, userID];
        NSDictionary *json = [Request getRequest:url];
        NSLog(@"GET KEY : %@", json);
        
        NSString *stringDate = [json objectForKey:@"last_update"];
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    stringDate = [stringDate stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];
        NSLog(@"string date : %@", stringDate);
    
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
        NSDate *date = [dateFormat dateFromString:stringDate];
        NSLog(@"translated date : %@", date);
        NSString *secureKey = [json objectForKey:@"key"];
        
        user.secureKeyDate = date;
        user.secureKey = secureKey;
        
        NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return secureKey;
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
