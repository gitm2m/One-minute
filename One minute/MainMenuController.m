//
//  MainMenuController.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import "MainMenuController.h"

#import "CameraController.h"
#import "WorkspacesController.h"

@implementation MainMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (IBAction) camera {
    
    if (cameraController == nil) {
        cameraController = [[CameraController alloc] initWithNibName:@"CameraController" bundle:nil];
    }
    
    [self.navigationController pushViewController:cameraController animated:YES];
}



- (IBAction) workspace {
    if (workspacesController == nil) {
        workspacesController = [[WorkspacesController alloc] initWithNibName:@"WorkspacesController" bundle:nil];
    }
    [workspacesController updateWorkspaces];
    [self.navigationController pushViewController:workspacesController animated:YES];
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
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    
    return NO;
}

@end
