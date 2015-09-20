//
//  HeaderPackDetailView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "HeaderPackDetailView.h"

@implementation HeaderPackDetailView

- (void)initHeader:(Pack *)pack {
    self.images = [[NSMutableArray alloc] init];
    self.packLabel.text = pack.title;
    /*for (Album *album in pack.listOfAlbums) {
        [images addObject:album.image];
    }*/
    [self.images addObject:@"onandon.jpg"];
    [self.images addObject:@"recognise.jpg"];
    [self.images addObject:@"motifs.jpg"];
    self.packImage = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.packImage];
    self.packImage.contentMode = UIViewContentModeScaleToFill;
    [self bringSubviewToFront:self.packLabel];
    
    self.index = 0;
    
   // [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //[self startTheBackgroundJob];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self startTheBackgroundJob];
            
        });    
    });
}

- (void)startTheBackgroundJob {
    UIImage *toImage = [UIImage imageNamed:[self.images objectAtIndex:self.index]];
    [UIView transitionWithView:self.packImage
                        duration:5.0f
                        options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.packImage.image = toImage;
                        } completion:^(BOOL finished) {
                            self.index++;
                            if (self.index == self.images.count) {
                                self.index = 0;
                            }
                            [self startTheBackgroundJob];
                        }];
}

@end
