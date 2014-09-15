//
//  Connexion.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connexion : NSObject

@property (strong, nonatomic) NSUserDefaults *prefs;
@property (assign, nonatomic) bool accessGranted;
@property (assign, nonatomic) int userID;

@end
