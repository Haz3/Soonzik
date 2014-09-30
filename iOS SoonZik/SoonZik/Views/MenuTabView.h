//
//  MenuTabView.h
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTabDelegate.h"

@interface MenuTabView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSArray *tableImageData;

@property (strong, nonatomic) id<MenuTabDelegate> clickDelegate;

- (void)loadWithData:(NSMutableArray *)array and:(NSMutableArray *)array2;

-(void)initTableView;

@end
