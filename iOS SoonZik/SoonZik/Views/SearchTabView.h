//
//  SearchTabView.h
//  SoonZik
//
//  Created by devmac on 28/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTabView : UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *filteredData;

- (void)initContent;
//@property (strong, nonatomic) id<MenuTabDelegate> clickDelegate;

@end
