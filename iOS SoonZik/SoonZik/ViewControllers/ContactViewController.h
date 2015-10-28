//
//  ContactViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 27/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"

@interface ContactViewController : TypeViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;

@end
