//
//  PlaylistsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PlaylistsController.h"

@implementation PlaylistsController

+ (Playlist *)createAPlaylist:(Playlist *)playlist {
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net create:playlist];
    
    Playlist *p;
    if ([[json objectForKey:@"code"] intValue] != 503) {
        p = [[Playlist alloc] initWithJsonObject:[json objectForKey:@"content"]];
    } else {
        p = [[Playlist alloc] init];
        p.identifier = -1;
    }
    return p;
}

+ (BOOL)addToPlaylist:(Playlist *)playlist :(Music *)music {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@musics/addtoplaylist", API_URL];
    key = [Crypto getKey];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&id=%i&playlist_id=%i", user.identifier, secureKey, music.identifier, playlist.identifier];
    
    NSDictionary *json = [Request postRequest:post url:url];
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    
    return false;
}

+ (BOOL)removeFromPlaylist:(Playlist *)playlist :(Music *)music {
    NSString *url, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    
    url = [NSString stringWithFormat:@"%@musics/delfromplaylist?user_id=%i&secureKey=%@&playlist_id=%i&id=%i", API_URL, user.identifier, secureKey, playlist.identifier, music.identifier];
    
    NSDictionary *json = [Request getRequest:url];
    
    if ([[json objectForKey:@"code"] intValue] == 200) {
        return true;
    }
    
    return false;
}

@end
