//
//  Socket.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Socket.h"
#import "Crypto.h"
#import "WebSocketRailsDispatcher.h"
#import "WebSocketRailsChannel.h"

@implementation Socket {
    WebSocketRailsDispatcher *dispatcher;
}

static Socket *sharedSocket = nil;    // static instance variable

+ (Socket *)sharedCenter {
    if (sharedSocket == nil) {
        sharedSocket = [[Socket alloc] init];
    }
    return sharedSocket;
}

// to call the instance : [[Socket shareCenter] <name of the method>]

// ENVOYER SECURE_KEY ET USER_ID A CHAQUE REQUETE

- (id)init {
    self = [super init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self connect];
    [self bindEvents];
    
    return self;
}

- (void)connect {
    dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://soonzikapi.herokuapp.com/websocket"/*@"ws://lvh.me:3000/websocket"*/]];
    [dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Yay! Connected!");
    }];
    [dispatcher connect];
}

- (void)disconnect {
    [dispatcher bind:@"connection_closed" callback:^(id data) {
        NSLog(@"Disconnected!");
    }];
    [dispatcher disconnect];
}

- (void)bindEvents {
    [dispatcher bind:@"newMsg" callback:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [dispatcher bind:@"onlineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [dispatcher bind:@"newOnlineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [dispatcher bind:@"newOfflineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
}

/*- (void)globalEvent {
    [dispatcher bind:@"global_event" callback:^(id data) {
        NSLog(@"Global event: %@", data);
    }];
    [dispatcher trigger:@"global_event" data:[self eventDataWithString:@"global_event_test"] success:nil failure:nil];
}

- (void)nameSpaceEvent {
    [dispatcher bind:@"namespace.namespace_event" callback:^(id data) {
        NSLog(@"Namespace event: %@", data);
    }];
    [dispatcher trigger:@"namespace.namespace_event" data:[self eventDataWithString:@"namespace.namespace_event_test"] success:nil failure:nil];
}

- (void)channelEvent {
    WebSocketRailsChannel *testChannel = [dispatcher subscribe:@"channel_event"];
    [testChannel bind:@"channel_event" callback:^(id data) {
        NSLog(@"Channel event: %@", data);
    }];
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [testChannel trigger:@"channel_event" message:@"channel_event_test"];
    });
}*/

- (void)whoIsOnline {
    NSString *key = [Crypto getKey:self.user.identifier];
    NSString *conca = [NSString stringWithFormat:@"%@%@", self.user.salt, key];
    NSString *secureKey = [Crypto sha256HashFor:conca];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i", self.user.identifier], @"user_id",
                         secureKey, @"secureKey",
                         nil];
    
    [dispatcher trigger:@"who_is_online" data:@{@"data": dic} success:^(id data) {
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Falure event: %@", data);
    }];
}

- (void)sendMessage:(NSString *)msg toUserId:(int)userID {
    NSString *key = [Crypto getKey:self.user.identifier];
    NSString *conca = [NSString stringWithFormat:@"%@%@", self.user.salt, key];
    NSString *secureKey = [Crypto sha256HashFor:conca];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i", self.user.identifier], @"user_id",
                         secureKey, @"secureKey",
                         msg, @"messageValue",
                         [NSString stringWithFormat:@"%i", userID], @"toWho",
                         nil];
   
    [dispatcher trigger:@"messages.send" data:@{@"data": dic} success:^(id data) {
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Falure event: %@", data);
    }];
}

@end
