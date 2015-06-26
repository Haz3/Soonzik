//
//  User.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "User.h"
#import "Address.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation User

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.email = [json objectForKey:@"email"];
    self.username = [json objectForKey:@"username"];
    self.firstname = [json objectForKey:@"fname"];
    self.lastname = [json objectForKey:@"lname"];
    self.birthday = [json objectForKey:@"birthday"];
    self.image = [json objectForKey:@"image"];
    self.newsletter = [[json objectForKey:@"newsletter"] boolValue];
    self.desc = [json objectForKey:@"description"];
    self.salt = [json objectForKey:@"salt"];
  //  self.phoneNbr = [json objectForKey:@"phoneNumber"];
  //  self.facebook = [json objectForKey:@"facebook"];
  //  self.twitter = [json objectForKey:@"twitter"];
  //  self.google = [json objectForKey:@"googlePlus"];
  //  self.idAPI = [json objectForKey:@"idAPI"];
   // self.follows = [[NSArray alloc] init];
    self.friends = [[NSMutableArray alloc] init];
    NSArray *friends = [json objectForKey:@"friends"];
    for (NSDictionary *dict in friends) {
        [self.friends addObject:[self getFriend:dict]];
    }
    
    //self.address = [[Address alloc] initWithJsonObject:[json objectForKey:@"address"]];
    //self.isAnArtist = [json objectForKey:@"twitter"];
    
    return self;
}

- (User *)getFriend:(NSDictionary *)json {
    NSLog(@"getFriend");
    User *friend = [[User alloc] initWithJsonObject:json];
    return friend;
}

+ (BOOL)follow:(int)artistId {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@users/follow", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    NSLog(@"artist id : %i", artistId);
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&follow_id=%i", user.identifier, secureKey, artistId];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"%@", [json objectForKey:@"content"]);
    
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
    NSLog(@"artist id : %i", artistId);
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&follow_id=%i", user.identifier, secureKey, artistId];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"%@", [json objectForKey:@"content"]);
    
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
    NSLog(@"%@", [json objectForKey:@"content"]);
    NSArray *arr = [json objectForKey:@"content"];
    
    NSMutableArray *listOfFriends = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFriends addObject:user];
    }
    
    return listOfFriends;
}

+ (NSMutableArray *)getFollows {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *url = [NSString stringWithFormat:@"%@users/%i/follows", API_URL, user.identifier];
    
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"%@", [json objectForKey:@"content"]);
    NSArray *arr = [json objectForKey:@"content"];

    NSMutableArray *listOfFollows = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFollows addObject:user];
    }
    
    return listOfFollows;
}

+ (NSMutableArray *)getFollowers {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *url = [NSString stringWithFormat:@"%@users/%i/followers", API_URL, user.identifier];
    
    NSDictionary *json = [Request getRequest:url];
    NSLog(@"%@", [json objectForKey:@"content"]);
    NSArray *arr = [json objectForKey:@"content"];
    
    NSMutableArray *listOfFollowers = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in arr) {
        User *user = [[User alloc] initWithJsonObject:dict];
        [listOfFollowers addObject:user];
    }
    
    return listOfFollowers;
}

+ (BOOL)uploadImage:(NSDictionary *)info {
    NSString *url, *post, *key, *conca, *secureKey;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
  
    UIImage *cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    __block NSData *imageData;
    __block NSString *imageFormat;
    __block NSString *imageOriginalName;
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        NSArray *substrings = [[imageRep filename] componentsSeparatedByString:@"."];
        NSString *format = [substrings objectAtIndex:1];
        NSLog(@"substring : %@", format);
        
        imageOriginalName = [substrings objectAtIndex:0];
        
        if ([format isEqualToString:@"JPG"]) {
            imageFormat = @"image/jpeg";
            imageData = UIImageJPEGRepresentation(cameraImage, 1);
        } else if ([format isEqualToString:@"PNG"]) {
            imageFormat = @"image/png";
            imageData = UIImagePNGRepresentation(cameraImage);
        }
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    url = [NSString stringWithFormat:@"%@users/upload", API_URL];
    key = [Crypto getKey:user.identifier];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&type=image&file[content_type]=%@&file[original_filename]=%@&file[tempfile]=%@", user.identifier, secureKey, imageFormat, imageOriginalName, imageData];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"%@", [json objectForKey:@"content"]);
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    return false;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.identifier] forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.firstname forKey:@"firstname"];
    [aCoder encodeObject:self.lastname forKey:@"lastname"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.salt forKey:@"salt"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.facebook forKey:@"facebook"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.google forKey:@"google"];
    [aCoder encodeObject:self.follows forKey:@"follows"];
    [aCoder encodeObject:self.friends forKey:@"friends"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.newsletter] forKey:@"newsletter"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.firstname = [aDecoder decodeObjectForKey:@"firstname"];
        self.lastname = [aDecoder decodeObjectForKey:@"lastname"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.salt = [aDecoder decodeObjectForKey:@"salt"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.facebook = [aDecoder decodeObjectForKey:@"facebook"];
        self.twitter = [aDecoder decodeObjectForKey:@"twitter"];
        self.google = [aDecoder decodeObjectForKey:@"google"];
        self.follows = [aDecoder decodeObjectForKey:@"follows"];
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
        self.newsletter = [aDecoder decodeObjectForKey:@"newsletter"];
    }
    return self;
}

- (NSString *)toParameters {
    return [NSString stringWithFormat:@"user[fname]=%@&user[lname]=%@&user[email]=%@&user[username]=%@", self.firstname, self.lastname, self.email, self.username];
}

@end
