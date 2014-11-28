//
//  MenuTabView.m
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "MenuTabView.h"
#import "MenuTableViewCell.h"

@implementation MenuTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)initTableView
{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];

    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadWithData:(NSMutableArray *)array and:(NSMutableArray *)array2
{
    self.tableData = [NSArray arrayWithArray:array];
    self.tableImageData = [NSArray arrayWithArray:array2];
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    [cell initCell];
    cell.title.text = [self.tableData objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:[self.tableImageData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.clickDelegate clickedAtIndex:indexPath.row];
}

@end
