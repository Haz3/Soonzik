//
//  Attachment.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"

@interface Attachment : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *contentType;

@end
