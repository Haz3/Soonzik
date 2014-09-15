//
//  UserAnnotation.h
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserAnnotation : NSObject <MKAnnotation>

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *username;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord username:(NSString *)username track:(NSString *)track artist:(NSString *)artist album:(NSString *)album;

@end
