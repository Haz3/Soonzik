//
//  Network.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Network.h"
#import "Playlist.h"
#import "User.h"

@implementation Network

- (NSDictionary *) getJsonWithClassName:className
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users", API_URL];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs", API_URL];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics", API_URL];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums", API_URL];
    } else if ([className isEqualToString:@"News"]) {
        url = [NSString stringWithFormat:@"%@news", API_URL];
    } else if ([className isEqualToString:@"UserListen"]) {
        url = [NSString stringWithFormat:@"%@listenings", API_URL];
    } else if ([className isEqualToString:@"Genre"]) {
        url = [NSString stringWithFormat:@"%@genres", API_URL];
    } else if ([className isEqualToString:@"Influence"]) {
        url = [NSString stringWithFormat:@"%@influences", API_URL];
    }
    
    return [Request getRequest:url];
}

- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"News"]) {
        url = [NSString stringWithFormat:@"%@news/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"UserListen"]) {
        url = [NSString stringWithFormat:@"%@listenings/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Genre"]) {
        url = [NSString stringWithFormat:@"%@genres/%i", API_URL, identifier];
    }
    
    return [Request getRequest:url];
}

- (NSDictionary *) findJsonElementWithClassName:className andValues:(NSString *)values
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"Playlist"]) {
        url = [NSString stringWithFormat:@"%@playlists/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Battle"]) {
        url = [NSString stringWithFormat:@"%@battles/find?%@", API_URL, values];
    }
    
    return [Request getRequest:url];
}

- (NSDictionary *)getJsonClient:(NSString *)token email:(NSString *)email uid:(NSString *)uid type:(int)type
{
    NSString *tok;
    if (type == 0)
        tok = [self getSocialToken:uid andType:@"facebook"];
    if (type == 1)
        tok = [self getSocialToken:uid andType:@"twitter"];
    if (type == 2)
        tok = [self getSocialToken:uid andType:@"google"];
    
    NSString *url;
    NSString *post;
    NSString *conca;
    NSString *secureKey;
    
    url = [NSString stringWithFormat:@"%@social-login", API_URL];
    conca = [NSString stringWithFormat:@"%@%@%@", uid, tok, FIX_SALT];
    secureKey = [Crypto sha256HashFor:conca];
    if (type == 0)
        post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"facebook", secureKey, token];
    if (type == 1)
        post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"twitter", secureKey, token];
    if (type == 2)
        post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"google", secureKey, token];

    return [Request postRequest:post url:url];
}

- (NSString *)getSocialToken:(NSString *)uid andType:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@getSocialToken/%@/%@", API_URL, uid, type];
    
    NSDictionary *results = [Request getRequest:url];
    return (NSString *)[results objectForKey:@"key"];
}

- (NSDictionary *)getJsonClient:(NSString *)email andPassword:(NSString *)password
{
    NSString *url = [NSString stringWithFormat:@"%@login/", API_URL];NSLog(@"URL : %@", url);
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];NSLog(@"post : %@", post);
    return [Request postRequest:post url:url];
}

- (NSDictionary *)create:(id)elem
{
    NSString *url;
    NSString *post;
    NSString *key;
    NSString *conca;
    NSString *secureKey;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([elem isKindOfClass:[Playlist class]]) {
        url = [NSString stringWithFormat:@"%@playlists/save", API_URL];
        Playlist *playlist = (Playlist *)elem;
        key = [Crypto getKey:user.identifier];
        conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
        secureKey = [Crypto sha256HashFor:conca];
        post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&playlist[user_id]=%i&playlist[name]=%@", user.identifier, secureKey, user.identifier, playlist.title];
    }
    
    return [Request postRequest:post url:url];
}

- (NSDictionary *)update:(id)elem
{
    NSString *url;
    NSString *post;
    NSString *key;
    NSString *conca;
    NSString *secureKey;
    
    if ([elem isKindOfClass:[User class]]) {
        User *user = (User *)elem;
        key = [Crypto getKey:user.identifier];
        conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
        secureKey = [Crypto sha256HashFor:conca];
        NSString *userParams = [user toParameters];
        url = [NSString stringWithFormat:@"%@users/update/", API_URL];
        post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&%@", user.identifier, secureKey, userParams];
    }
    
    return [Request postRequest:post url:url];
}

- (NSDictionary *)destroy:(id)elem
{
    NSString *url;
    NSString *key;
    NSString *conca;
    NSString *secureKey;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([elem isKindOfClass:[Playlist class]]) {
        Playlist *playlist = (Playlist *)elem;
        key = [Crypto getKey:user.identifier];  
        conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
        secureKey = [Crypto sha256HashFor:conca];
        url = [NSString stringWithFormat:@"%@playlists/destroy?user_id=%i&secureKey=%@&id=%i", API_URL, user.identifier, secureKey, playlist.identifier];
    }
    
    return [Request getRequest:url];
}

@end
