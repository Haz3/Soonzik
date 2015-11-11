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
        key = [Crypto getKey];
        conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
        secureKey = [Crypto sha256HashFor:conca];
        post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&playlist[user_id]=%i&playlist[name]=%@", user.identifier, secureKey, user.identifier, playlist.title];
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
        key = [Crypto getKey];  
        conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
        secureKey = [Crypto sha256HashFor:conca];
        url = [NSString stringWithFormat:@"%@playlists/destroy?user_id=%i&secureKey=%@&id=%i", API_URL, user.identifier, secureKey, playlist.identifier];
    }
    
    return [Request getRequest:url];
}

@end
