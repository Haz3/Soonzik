//
//  CalloutView.m
//  SoonZik
//
//  Created by LLC on 01/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "CalloutView.h"

@implementation CalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ok touch began");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"ok callout");
    
    if (point.x >= self.albumImage.frame.origin.x && point.x <= (self.albumImage.frame.origin.x + self.albumImage.frame.size.width)) {
        if (point.y >= self.albumImage.frame.origin.y && point.y <= (self.albumImage.frame.origin.y + self.albumImage.frame.size.height)) {
            NSLog(@"callout view selectionnee");
        }
    }
    
    return nil;
}

@end
