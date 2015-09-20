//
//  PackDetailViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PackDetailViewController.h"
#import "AlbumInPackTableViewCell.h"
#import "SVGKImage.h"
#import "HeaderPackDetailView.h"
#import "Description.h"
#import "PacksController.h"
#import "RepartitionAmountViewController.h"

@interface PackDetailViewController ()

@end

@implementation PackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = DARK_GREY;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.dataLoaded = true;
    [self launchLoadData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 4, 36, 36)];
    [closeButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
   if (self.fromSearch) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
   } else if (self.fromPack) {
       closeButton.hidden = true;
       self.navigationController.navigationBarHidden = false;
       self.navigationItem.leftBarButtonItem = nil;
       [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
   
}

- (void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    self.dataLoaded = NO;
    [self loadDataFromAPI];
    self.dataLoaded = YES;
    [self.tableView reloadData];
}

- (void)loadDataFromAPI {
    [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
    
    self.pack = [PacksController getPack:self.pack.identifier];
    
    [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
}

- (void)spinBegin {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    
    [self.spin startAnimating];
}

- (void)spinEnd {
    [self.spin stopAnimating];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (section == 0)
            return 320;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataLoaded) {
        if (indexPath.section == 0) {
            return 50;
        }
        return 44;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        HeaderPackDetailView *view = (HeaderPackDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderPackDetailView" owner:self options:nil] firstObject];
        [view initHeader:self.pack];
        return view;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataLoaded) {
        return 3;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (section == 0) {
            return self.pack.listOfAlbums.count;
        } if (section == 2) {
            return 1;
        }
        return self.pack.listOfDescriptions.count;
    }
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Album *album = [self.pack.listOfAlbums objectAtIndex:indexPath.row];
        AlbumInPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAlbum"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AlbumInPackTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellAlbum"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellAlbum"];
        }
        
        
        cell.albumLabel.text = album.title;
        cell.artistLabel.text = album.artist.username;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    else if (indexPath.section == 1) {
        Description *description = [self.pack.listOfDescriptions objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDescription"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDescription"];
        }
        
        cell.textLabel.text = description.text;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell sizeToFit];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDescription"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPurchase"];
    }
    
    cell.textLabel.text = [self.translate.dict objectForKey:@"buy_now"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell sizeToFit];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        RepartitionAmountViewController *vc = [[RepartitionAmountViewController alloc] initWithNibName:@"RepartitionAmountViewController" bundle:nil];
        vc.price = self.pack.price;
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Albums";
    } else if (section == 1) {
        return @"Description";
    }
    
    return nil;
}

@end
