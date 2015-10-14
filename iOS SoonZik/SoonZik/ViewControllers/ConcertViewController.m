//
//  ConcertViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 01/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ConcertViewController.h"

@interface ConcertViewController ()

@end

@implementation ConcertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DARK_GREY;
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else if (section == 1)
        return 3;
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 44;
    else if (indexPath.section == 1)
        return 30;
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Date";
    else if (section == 1)
        return @"Adresse";
    
    return @"Plus d'infos";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.concert.date];
            cell.textLabel.text = [NSString stringWithFormat:@"Le %.2i/%.2i/%.4i", components.day, components.month, components.year];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.concert.address.streetNbr, self.concert.address.street];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.concert.address.zipCode, self.concert.address.city];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.concert.address.country];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.concert.url];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    
    
    return cell;
}

@end
