//
//  FriendsViewController.m
//  SoonZik
//
//  Created by LLC on 09/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTableViewCell.h"
#import "ChatViewController.h"
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
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.selectedRow = -1;
    self.selectedSection = -1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self getFriendList];
}

- (void)goToChat
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:chatVC animated:YES];
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
    if (indexPath.row == self.selectedRow && indexPath.section == self.selectedSection) {
        return 100;
    }
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
    NSString *keyPath = [self.listOfFirstLetter objectAtIndex:indexPath.section];
    NSArray *listOfPeopleInThisSection = [self.listOfFriends valueForKeyPath:keyPath];
    User *p = [listOfPeopleInThisSection objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.selectedRow && indexPath.section == self.selectedSection) {
        static NSString *cellIdentifier = @"cellIDOpen";
        
        FriendsTableViewCell *cell = (FriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FriendsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            cell = (FriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        }
        
        [cell.chatButton addTarget:self action:@selector(goToChat) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.font = SOONZIK_FONT_BODY_MEDIUM;
        cell.nameLabel.text = p.username;
        
        cell = [self detailFriendImageRoundedWithImage:[UIImage imageNamed:@"artist1.jpg"] andCell:cell];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lineView];
        
        return cell;
    }
    
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    cell.textLabel.text = p.username;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = (int)indexPath.row;
    self.selectedSection = (int)indexPath.section;
    [tableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.listOfFirstLetter.count)];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    //[tableView beginUpdates];
    //[tableView endUpdates];
}

- (FriendsTableViewCell *) detailFriendImageRoundedWithImage:(UIImage *)image andCell:(FriendsTableViewCell *)cell
{
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.contents = (id)image.CGImage;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.image = image;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
