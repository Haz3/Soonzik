//
//  Socket.h
//  SoonZik
//
//  Created by Maxime Sauvage on 23/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject <NSStreamDelegate>

@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;

+ (Socket *)sharedCenter;

- (void)sendMessage:(NSString *)msg;
- (void)whoIsOnline;

@end
