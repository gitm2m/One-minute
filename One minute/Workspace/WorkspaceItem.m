//
//  WorkspaceItem.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import "WorkspaceItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation WorkspaceItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[self layer] setBorderWidth:2];
        [[self layer] setCornerRadius:15];
        [[self layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[self layer] setShadowColor:[UIColor lightGrayColor].CGColor];
        [[self layer] setShadowRadius:0.75];
        [self setBackgroundColor:[UIColor darkGrayColor]];
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

- (void)dealloc
{
    [super dealloc];
}

@end
