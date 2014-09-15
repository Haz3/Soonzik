//
//  SearchTabView.m
//  SoonZik
//
//  Created by devmac on 28/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "SearchTabView.h"

@implementation SearchTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initContent
{
    [self setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
        
    self.searchBar.delegate = self;
        
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self endEditing:YES];
    
    if (self.tableData.count == 0) {
        self.tableView.hidden = YES;
        self.noResultLabel.hidden = NO;
    }
    //[searchBar resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
