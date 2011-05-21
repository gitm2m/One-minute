//
//  WorkspacesController.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import "WorkspacesController.h"

#import "WorkspaceItem.h"


@implementation WorkspacesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documents = [Utils documentsDirectory];
    
    workspaces = [[NSMutableArray alloc] initWithArray:[manager contentsOfDirectoryAtPath:documents error:nil]];
    
    NSArray *arr = [NSArray arrayWithArray:[self.view subviews]];
    
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    
    int x = 5;
    int y = 5;
    int c = 0;
    
    for (NSString *name in workspaces) {
        WorkspaceItem *item = [[WorkspaceItem alloc] initWithFrame:CGRectMake(x, y, 153, 100)];
        [self.view addSubview:item];
        x += 158;
        c++;
        if (c == 3) {
            y += 105;
            x = 5;
            c = 0;
        }
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
