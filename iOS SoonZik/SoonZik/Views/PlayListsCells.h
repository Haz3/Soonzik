//
//  PlayListsCells.h
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListsCells : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trackTitle;

- (void)initCell;

@end
