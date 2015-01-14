//
//  FriendsTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *detailView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *chatButton;

@end
