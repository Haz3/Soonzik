//
//  RepartitionAmountViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "RepartitionAmountViewController.h"
#import "RepartionTableViewCell.h"

@interface RepartitionAmountViewController ()

@end

@implementation RepartitionAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tableView addGestureRecognizer:tap];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.price = 30;
    
    [self initializeCells];
}

- (void)initializeCells {
    self.cells = [NSMutableArray new];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    self.textField = [[UITextField alloc] initWithFrame:cell.frame];
    self.textField.placeholder = [self.translate.dict objectForKey:@"choose_amount"];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.text = [NSString stringWithFormat:@"%.1f", self.price];
    [cell.contentView addSubview:self.textField];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [self.cells addObject:cell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RepartionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    for (int i = 1; i <= 3; i++) {
        RepartionTableViewCell *cell = (RepartionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DARK_GREY;
        cell.value.textColor = [UIColor whiteColor];
        
        cell.slider.minimumValue = 0;
        cell.slider.maximumValue = self.price;
        cell.slider.continuous = true;
        
        if (i == 1) {
            cell.slider.value = 0.65 * self.price;
        } else if (i == 2) {
            cell.slider.value = 0.20 * self.price;
        } else if (i == 3) {
            cell.slider.value = 0.15 * self.price;
        }
        
        cell.slider.tag = i;
        cell.value.text = [NSString stringWithFormat:@"%.2f%%", cell.slider.value];
        [cell.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.cells addObject:cell];
    }
    
    UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"b"];
    UIButton *validButton = [[UIButton alloc] initWithFrame:cell2.frame];
    [validButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [validButton setTitle:[self.translate.dict objectForKey:@"buy_now"] forState:UIControlStateNormal];
    [validButton addTarget:self action:@selector(buyPack) forControlEvents:UIControlEventTouchUpInside];
    [cell2.contentView addSubview:validButton];
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.backgroundColor = [UIColor clearColor];
    
    [self.cells addObject:cell2];

}

- (void)buyPack {
    NSLog(@"buy_pack");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self.translate.dict objectForKey:@"repartition_choice"];
    } else if (section == 1) {
        return [self.translate.dict objectForKey:@"repartition_artist"];
    } else if (section == 2) {
        return[self.translate.dict objectForKey:@"repartition_association"];
    } else if (section == 3) {
        return [self.translate.dict objectForKey:@"repartition_site"];
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cells objectAtIndex:indexPath.section];
}

- (void)sliderChanged:(UISlider *)slider {
    RepartionTableViewCell *cell1 = [self.cells objectAtIndex:1];
    RepartionTableViewCell *cell2 = [self.cells objectAtIndex:2];
    RepartionTableViewCell *cell3 = [self.cells objectAtIndex:3];
    
    if (slider.tag == 1) {
        cell2.slider.value = 1 * (self.price - cell1.slider.value);
        cell3.slider.value = 0.75 * (self.price - cell1.slider.value);
    } else if (slider.tag == 2) {
        cell1.slider.value = 1 * (self.price - cell2.slider.value);
        cell3.slider.value = (0.15 / 0.65) * (self.price - cell2.slider.value);
    } else if (slider.tag == 3) {
        cell1.slider.value = 1 * (self.price - cell3.slider.value);
        cell2.slider.value = (0.20 / 0.60) * (self.price - cell3.slider.value);
    }
    
    cell1.value.text = [NSString stringWithFormat:@"%.1f", cell1.slider.value];
    cell2.value.text = [NSString stringWithFormat:@"%.1f", cell2.slider.value];
    cell3.value.text = [NSString stringWithFormat:@"%.1f", cell3.slider.value];
}

- (NSArray *)getCells {
    return @[[self.cells objectAtIndex:1], [self.cells objectAtIndex:2], [self.cells objectAtIndex:3]];
}

- (void)recalculateRepartition {
    for (int i = 1; i < self.cells.count-1; i++) {
        NSLog(@"cell");
        RepartionTableViewCell *cell = [self.cells objectAtIndex:i];
        if (cell.slider.tag == 1) {
            cell.slider.value = 0.65 * self.price;
        } else if (cell.slider.tag == 2) {
            cell.slider.value = 0.20 * self.price;
        } else if (cell.slider.tag == 3) {
            cell.slider.value = 0.15 * self.price;
        }
        cell.value.text = [NSString stringWithFormat:@"%.1f", cell.slider.value];
        cell.slider.maximumValue = self.price;
    }
    
    [self.tableView reloadData];
}

- (void)didTapOnTableView:(UIGestureRecognizer *)reco {
    [self.textField resignFirstResponder];
    self.price = [self.textField.text floatValue];
    NSLog(@"self.price : %f", self.price);
    [self recalculateRepartition];
}

@end
