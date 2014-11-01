//
//  PlayListsHeaderView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 14/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListsHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *playlistLabel;
@property (nonatomic, weak) IBOutlet UILabel *nbrOfTracks;
@property (nonatomic, weak) IBOutlet UIImageView *album1Image;
@property (nonatomic, weak) IBOutlet UIImageView *album2Image;
@property (nonatomic, weak) IBOutlet UIImageView *album3Image;
@property (nonatomic, weak) IBOutlet UIImageView *album4Image;

@end
