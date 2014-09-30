//
//  ExploreViewController.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ExploreViewController.h"
#import "ExploreCollectionViewCell.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

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
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setFrame:CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height - self.playerPreviewView.frame.size.height)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ExploreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    ExploreCollectionViewCell *cell = (ExploreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    [cell initCell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"element: %i", indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
