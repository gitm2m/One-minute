//
//  WorkspacesController.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//


#import "EncoderImagesToMovie.h"

#import "WorkspaceFileListViewer.h"
#import "WorkspacesController.h"
#import "WorkspaceItem.h"

#import <QuartzCore/QuartzCore.h>

@implementation WorkspacesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) movieCreatorOfWorkspace: (NSString*)name {
    if (encodeController == nil) {
        encodeController = [[EncoderImagesToMovie alloc] initWithNibName:@"EncoderImagesToMovie" bundle:nil];
    }
    [encodeController setWorkspaceName:name];
    [self.navigationController pushViewController:encodeController animated:YES];
}









- (void) updateWorkspaces {
    
    if (scrollView == nil) {
        updateInDidLoad = YES;
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documents = [Utils documentsDirectory];
    
    
    if (workspaces == nil) {
        workspaces = [[NSMutableArray alloc] initWithArray:[manager contentsOfDirectoryAtPath:documents error:nil]];
    } else {
        [workspaces removeAllObjects];
        [workspaces addObjectsFromArray:[manager contentsOfDirectoryAtPath:documents error:nil]];
    }
    
    
    NSArray *arr = [NSArray arrayWithArray:[scrollView subviews]];
    
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    
    int x = 5;
    int y = 5;
    int c = 0;
    
    for (NSString *name in workspaces) {
                
        WorkspaceItem *item = [[WorkspaceItem alloc] initWithFrame:CGRectMake(x, y, 153, 100)];
        [item setTitleName:name];
        [item setDelegate:self];
        [scrollView addSubview:item];
        [item release];
        
        x += 158;
        c++;
        if (c == 3) {
            y += 105;
            x = 5;
            c = 0;
        }
    }
    
    if (c > 0) {
        y += 105;
    }
    
    [scrollView setContentSize:CGSizeMake(480, y)];
}



- (void)dealloc
{
    if (encodeController != nil) {
        [encodeController release];
        encodeController = nil;
    }
    
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
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (updateInDidLoad) {
        [self updateWorkspaces];
    }
    [self.navigationItem setTitle:@"Workspaces"];
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
