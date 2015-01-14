//
//  AddPlaylistViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 08/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClosePopupDelegate <NSObject>

- (void)closePopup:(NSString *)country;

@end

@interface AddPlaylistViewController : UIViewController

@property (nonatomic, strong) id<ClosePopupDelegate> closePopupDelegate;

@end
