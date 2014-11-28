//
//  Network.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Network.h"

#define URL @"http://api.lvh.me:3000/"

@implementation Network

- (NSDictionary *) getJsonWithClassName:className
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users", URL];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs", URL];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics", URL];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums", URL];
    }
    
    NSLog(@"path : %@", url);
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    }
    
    return results;
}

- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users/%i", URL, identifier];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs/%i", URL, identifier];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics/%i", URL, identifier];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums/%i", URL, identifier];
    }

    
    NSLog(@"path : %@", url);
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    }
    
    return results;
}

- (NSDictionary *)getJsonClient:(NSString *)token email:(NSString *)email
{
    NSString *encodedString = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.lvh.me:3000/loginFB/%@?email=%@", token, encodedString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        if (error.code == -1009) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Pas de connexion réseau disponible" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    NSLog(@"results : %@", results);
    
    return results;
}


@end
