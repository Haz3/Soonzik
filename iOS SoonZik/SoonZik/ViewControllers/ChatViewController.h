//
//  ChatViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 16/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessagingViewController.h"

@interface ChatViewController : SOMessagingViewController

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end
