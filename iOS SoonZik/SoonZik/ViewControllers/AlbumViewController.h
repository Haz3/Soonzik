//
//  AlbumViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@end
