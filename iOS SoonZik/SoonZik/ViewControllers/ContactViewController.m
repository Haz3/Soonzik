//
//  ContactViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 27/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.font = SOONZIK_FONT_BODY_SMALL;
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    self.descLabel.text = @"Un commentaire, un retour ou quelque chose d'autre à partager avec nous? Nous sommes à ton écoute.";
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.font = SOONZIK_FONT_BODY_MEDIUM;
}

- (void)sendMessage {
    
    self.textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    
    return true;
}

@end
