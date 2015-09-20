//
//  RepartitionAmountViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Translate.h"

@interface RepartitionAmountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) float price;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Translate *translate;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *cells;

@end
