//
//  Socket.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Socket.h"

@implementation Socket

static Socket *sharedSocket = nil;    // static instance variable

+ (Socket *)sharedCenter {
    if (sharedSocket == nil) {
        sharedSocket = [[Socket alloc] init];
    }
    return sharedSocket;
}

// singleton methods
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedCenter];
}

// to call the instance : [[Socket shareCenter] <name of the method>]

- (id)init {
    self = [super init];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"http://soonzikapi.herokuapp.com", 8080, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
    
    /*NSString *response  = [NSString stringWithFormat:@"iam:%@", inputNameField.text];
     NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
     [outputStream write:[data bytes] maxLength:[data length]];*/
    
    return self;
}

- (void)whoIsOnline {
    NSString *request = @"who_is_online";
    NSData *data = [[NSData alloc] initWithData:[request dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)sendMessage:(NSString *)msg {
    NSString *request  = [NSString stringWithFormat:@"newMsg:%@", msg];
    NSData *data = [[NSData alloc] initWithData:[request dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

@end
