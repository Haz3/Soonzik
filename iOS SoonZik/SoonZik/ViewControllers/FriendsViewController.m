//
//  FriendsViewController.m
//  SoonZik
//
//  Created by LLC on 09/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "FriendsViewController.h"
#import "User.h"

#define CELL_HEIGHT 40

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.nameLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.x + self.navigationController.navigationBar.frame.size.height + self.statusBarHeight, self.tableView.frame.size.width,self.tableView.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.playerPreviewView.frame.size.height-self.statusBarHeight);
    
    NSLog(@"taille tableview: %f", self.screenHeight - self.statusBarHeight - self.navigationController.navigationBar.frame.size.height - self.playerPreviewView.frame.size.height * 2);
    
    self.detailView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
    
    [self getFriendList];

    self.detailViewOpen = NO;
}

- (void)getFriendList
{
    self.listOfFriendsTMP = [[NSMutableArray alloc] init];
    self.listOfFriendsTitle = [[NSMutableArray alloc] init];
    
    User *p = nil;
    
    p = [[User alloc] init];
    p.username = @"maxsvg";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"martin";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"gery";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];

    p = [[User alloc] init];
    p.username = @"kevin";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"florian";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"flo";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"julien";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"julie";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    p = [[User alloc] init];
    p.username = @"maxime";
    [self.listOfFriendsTitle addObject:p.username];
    [self.listOfFriendsTMP addObject:p];
    
    [self getFriendListInOrder];
    
    self.listOfFriends = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.listOfFriendsTMP.count; i++) {
        User *pers = [self.listOfFriendsTMP objectAtIndex:i];
        NSString *keyPath = [NSString stringWithFormat:@"%c", [pers.username characterAtIndex:0]];
        if ([self.listOfFriends valueForKeyPath:keyPath] == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:pers];
            [self.listOfFriends setValue:array forKey:keyPath];
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.listOfFriends valueForKeyPath:keyPath]];
            [array addObject:pers];
            [self.listOfFriends setValue:array forKey:keyPath];
        }
    }
    
    NSLog(@"dictionnary of persons : %@", self.listOfFriends);
}

- (void)getFriendListInOrder
{
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.listOfFriendsTitle sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
    
    [self getListOfFirstLetter];
    
    NSMutableArray *newList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfFriendsTitle.count; i++) {
        for (int j = 0; j < self.listOfFriendsTMP.count; j++) {
            User *p = [self.listOfFriendsTMP objectAtIndex:j];
            if ([p.username isEqualToString:[self.listOfFriendsTitle objectAtIndex:i]]) {
                [newList addObject:p];
            }
        }
    }
    self.listOfFriendsTMP = newList;
}

- (void)getListOfFirstLetter
{
    self.listOfFirstLetter = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfFriendsTitle.count; i++) {
        [self.listOfFirstLetter addObject:[NSString stringWithFormat:@"%c", [[self.listOfFriendsTitle objectAtIndex:i] characterAtIndex:0]]];
    }
    
    NSMutableArray *uniqueArray = [[NSMutableArray alloc] init];
    for (NSString *str in self.listOfFirstLetter) {
        if (![uniqueArray containsObject:str])
            [uniqueArray addObject:str];
    }
    
    self.listOfFirstLetter = [NSMutableArray arrayWithArray:uniqueArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listOfFirstLetter.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *keyPath = [self.listOfFirstLetter objectAtIndex:section];
    NSArray *listOfPeopleInThisSection = [self.listOfFriends valueForKeyPath:keyPath];
    
    return listOfPeopleInThisSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.listOfFirstLetter objectAtIndex:section] uppercaseString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *letter = [self.listOfFirstLetter objectAtIndex:section];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
    label.font = SOONZIK_FONT_BODY_MEDIUM;
    label.textColor = [UIColor whiteColor];
    label.text = [letter uppercaseString];
    
    [sectionView addSubview:label];
    
    [sectionView setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        /*[tableView registerNib:[UINib nibWithNibName:@"PlayListsCells" bundle:nil] forCellReuseIdentifier:cellIdentifier];*/
        //cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *keyPath = [self.listOfFirstLetter objectAtIndex:indexPath.section];
    NSArray *listOfPeopleInThisSection = [self.listOfFriends valueForKeyPath:keyPath];
    User *p = [listOfPeopleInThisSection objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    cell.textLabel.text = p.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailFriendViewWithIndexPath:indexPath];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)showDetailFriendViewWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyPath = [self.listOfFirstLetter objectAtIndex:indexPath.section];
    NSArray *listOfPeopleInThisSection = [self.listOfFriends valueForKeyPath:keyPath];
    User *p = [listOfPeopleInThisSection objectAtIndex:indexPath.row];
    self.nameLabel.text = p.username;
    
    [self detailFriendImageRoundedWithImage:[UIImage imageNamed:@"artist1.jpg"]];
    
    if (!self.detailViewOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.detailView.frame.size.height + self.navigationController.navigationBar.frame.size.height + self.statusBarHeight, self.tableView.frame.size.width, self.tableView.frame.size.height - self.detailView.frame.size.height)];
        }];
        
        self.detailViewOpen = YES;
    }
}

- (void)detailFriendImageRoundedWithImage:(UIImage *)image
{
    [self.subLayer removeFromSuperlayer];
    self.subLayer = [CALayer layer];
    self.subLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.subLayer.shadowOffset = CGSizeMake(5, 5);
    self.subLayer.shadowRadius = 5.0;
    self.subLayer.shadowColor = [UIColor blackColor].CGColor;
    self.subLayer.shadowOpacity = 0.8;
    self.subLayer.frame = CGRectMake(self.detailView.center.x - 70, self.detailView.center.y - 140, 140, 140);
    self.subLayer.borderColor = [UIColor whiteColor].CGColor;
    self.subLayer.borderWidth = 2;
    self.subLayer.cornerRadius = 70;
    [self.detailView.layer addSublayer:self.subLayer];
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = self.subLayer.bounds;
    self.imageLayer.cornerRadius = 70;
    self.imageLayer.contents = (id)image.CGImage;
    self.imageLayer.masksToBounds = YES;
    [self.subLayer addSublayer:self.imageLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
