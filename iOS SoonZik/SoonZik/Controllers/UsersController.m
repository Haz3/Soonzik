//
//  UsersController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "UsersController.h"
#import "UserListen.h"

@implementation UsersController

+ (BOOL)follow:(int)artistId {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@users/follow", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    // NSLog(@"artist id : %i", artistId);
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&follow_id=%i", user.identifier, secureKey, artistId];
    
    NSDictionary *json = [Request postRequest:post url:url];
    // NSLog(@"%@", [json objectForKey:@"content"]);
    NSLog(@"json follow : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    return false;
}

+ (BOOL)unfollow:(int)artistId {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@users/unfollow", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    //NSLog(@"artist id : %i", artistId);
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&follow_id=%i", user.identifier, secureKey, artistId];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json follow : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 200) {
        return true;
    }
    return false;
}

+ (BOOL)addFriend:(int)userID {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@users/addfriend", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&friend_id=%i", user.identifier, secureKey, userID];
    
    NSLog(@"url : %@", url);
    NSLog(@"post : %@", post);
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json friend : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    return false;
}

+ (BOOL)delFriend:(int)userID {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@users/delfriend", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&friend_id=%i", user.identifier, secureKey, userID];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json friend : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 200) {
        return true;
    }
    return false;
}

+ (NSMutableArray *)getFriends {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *url = [NSString stringWithFormat:@"%@users/%i/friends", API_URL, user.identifier];
    
    NSDictionary *json = [Request getRequest:url];
    NSArray *arr = [json objectForKey:@"content"];
    
    NSMutableArray *listOfFriends = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFriends addObject:user];
    }
    
    return listOfFriends;
}

+ (NSMutableArray *)getFollows  :(int)userID {
    //NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    //User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *url = [NSString stringWithFormat:@"%@users/%i/follows", API_URL, userID];
    
    NSDictionary *json = [Request getRequest:url];
    //NSLog(@"%@", [json objectForKey:@"content"]);
    NSArray *arr = [json objectForKey:@"content"];
    
    NSMutableArray *listOfFollows = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFollows addObject:user];
    }
    
    return listOfFollows;
}

+ (NSMutableArray *)getFollowers  :(int)userID {
    //NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    //User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *url = [NSString stringWithFormat:@"%@users/%i/followers", API_URL, userID];
    
    NSDictionary *json = [Request getRequest:url];
    //NSLog(@"%@", [json objectForKey:@"content"]);
    NSArray *arr = [json objectForKey:@"content"];
    
    NSMutableArray *listOfFollowers = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFollowers addObject:user];
    }
    
    return listOfFollowers;
}

+ (BoughtContent *)getContent {
    BoughtContent *boughtContent = [[BoughtContent alloc] init];
    boughtContent.listOfMusics = [[NSMutableArray alloc] init];
    boughtContent.listOfAlbums = [[NSMutableArray alloc] init];
    boughtContent.listOfPacks = [[NSMutableArray alloc] init];
    
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    
    url = [NSString stringWithFormat:@"%@users/getmusics?user_id=%i&secureKey=%@", API_URL, user.identifier, secureKey];
    
    NSDictionary *json = [Request getRequest:url];
    
    NSDictionary *content = [json objectForKey:@"content"];
    NSArray *listOfMusics = [content objectForKey:@"musics"];
    NSArray *listOfAlbums = [content objectForKey:@"albums"];
    NSArray *listOfPacks = [content objectForKey:@"packs"];
    
    for (NSDictionary *dict in listOfMusics) {
        Music *music = [[Music alloc] initWithJsonObject:dict];
        [boughtContent.listOfMusics addObject:music];
    }
    for (NSDictionary *dict in listOfAlbums) {
        Album *album = [[Album alloc] initWithJsonObject:dict];
        [boughtContent.listOfAlbums addObject:album];
    }
    for (NSDictionary *dict in listOfPacks) {
        Pack *pack = [[Pack alloc] initWithJsonObject:[dict objectForKey:@"pack"]];
        [boughtContent.listOfPacks addObject:pack];
    }
    
    return boughtContent;
}

+ (BOOL)isArtist:(int)userID {
    NSString *url = [NSString stringWithFormat:@"%@users/%i/isartist", API_URL, userID];
    NSDictionary *json = [Request getRequest:url];
    NSDictionary *dict = [json objectForKey:@"content"];

    return [[dict objectForKey:@"artist"] boolValue];
}

+ (User *)getUser:(int)userID {
    NSString *url = [NSString stringWithFormat:@"%@users/%i", API_URL, userID];
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"json user : %@", json);
    return [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
}

+ (NSMutableArray *)getUsersInArea:(double)latitude :(double)longitude :(int)range {
    NSString *url = [NSString stringWithFormat:@"%@listenings/around/%f/%f/%i", API_URL, latitude, longitude, range];
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"%@", json);
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSArray *listOfListenings = [json objectForKey:@"content"];
    for (NSDictionary *dict in listOfListenings) {
        [res addObject:[[UserListen alloc] initWithJsonObject:dict]];
    }
    
    return res;
}

+ (User *)update:(User *)user {
    NSString *url;
    NSString *post;
    NSString *key;
    NSString *conca;
    NSString *secureKey;
    
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    url = [NSString stringWithFormat:@"%@users/update", API_URL];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&user[email]=%@&user[username]=%@&user[fname]=%@&user[lname]=%@&address[numberStreet]=%@&address[street]=%@&address[zipcode]=%@&address[city]=%@&address[country]=%@", user.identifier, secureKey, user.email, [user.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], user.firstname, user.lastname, user.address.streetNbr, [user.address.street stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], user.address.zipCode,  [user.address.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], user.address.country];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"user json : %@", json);
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
    }
    
    return nil;
}

@end
