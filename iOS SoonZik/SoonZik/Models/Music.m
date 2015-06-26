//
//  Music.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Music.h"

@implementation Music

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];

    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.duration = [[json objectForKey:@"duration"] intValue];
    self.file = [json objectForKey:@"file"];
    self.price = [[json objectForKey:@"price"] floatValue];
    
    self.artist = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    self.album = [[NSMutableArray alloc] init];
    
    Album *a = [[Album alloc] initWithJsonObject:[json objectForKey:@"album"]];
    if (a.identifier == 0) {
        Music *m = [Factory provideObjectWithClassName:@"Music" andIdentifier:self.identifier];
        a = m.album.firstObject;
    }
    [self.album  addObject:a];
    Album *al = self.album.firstObject;
    if (al) {
        self.image = al.image;
    }
    
    return self;
}

+ (BOOL)addToPlaylist:(Playlist *)playlist :(Music *)music {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@musics/addtoplaylist", API_URL];
    key = [Crypto getKey:user.identifier];
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
    
    key = [Crypto getKey:user.identifier];
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
