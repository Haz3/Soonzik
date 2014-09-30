//
//  Battle.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "User.h"

@interface Battle : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) User *artistOne;
@property (nonatomic, strong) User *artistTwo;
@property (nonatomic, assign) int artistOneVotes;
@property (nonatomic, assign) int artistTwoVotes;
@property (nonatomic, assign) int choice;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@end
