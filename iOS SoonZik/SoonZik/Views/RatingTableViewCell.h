//
//  RatingTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 04/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValueChangedProtocol <NSObject>

- (void)valueChanged:(float)value;

@end

@interface RatingTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *rateLabel;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic, strong) id<ValueChangedProtocol> delegate;

- (IBAction)rateSliderChanged:(UISlider *)slider;

@end
