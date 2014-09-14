//
//  EmailConnect.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Connexion.h"

@interface EmailConnect : Connexion

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

+ (void)emailConnect;

@end
