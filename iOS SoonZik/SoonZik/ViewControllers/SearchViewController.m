//
//  SearchViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    
    self.searchBar.delegate = self;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.noResultLabel.hidden = NO;
    
    self.tableData = [[NSMutableArray alloc] init];
    self.filteredData = [[NSMutableArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //if (self.isFiltered == YES)
    return self.filteredData.count;
    //else
    return [self.tableData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    /*Element *e;
     if (self.isFiltered == YES) {
     e = [self.filteredData objectAtIndex:indexPath.row];
     } else {
     e = [self.tableData objectAtIndex:indexPath.row];
     }
     
     cell.textLabel.text = e.title;*/
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.noResultLabel.hidden = YES;
    self.tableView.hidden = NO;
    if ([searchText length] == 0) {
        //self.isFiltered = NO;
    } else {
        /*self.isFiltered = YES;
         
         self.filteredData = [[NSMutableArray alloc] init];
         
         for (Element *e in self.tableData) {
         NSString *value = e.title;
         NSRange valueRange = [value rangeOfString:searchText options:NSCaseInsensitiveSearch];
         
         if (valueRange.location != NSNotFound) {
         [self.filteredData addObject:e];
         }
         }*/
    }
    //[self.tableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.tableData.count == 0) {
        self.tableView.hidden = YES;
        self.noResultLabel.hidden = NO;
    }
    [searchBar resignFirstResponder];
}

@end
