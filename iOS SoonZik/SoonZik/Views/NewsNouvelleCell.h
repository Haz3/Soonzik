//
//  NewsNouvelleCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 18/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareNewsDelegate.h"
#import "News.h"

@interface NewsNouvelleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellContent;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) News *news;

@property (nonatomic, strong) id<ShareNewsDelegate>shareDelegate;

- (void)initCellWithNews:(News *)news;

@end
