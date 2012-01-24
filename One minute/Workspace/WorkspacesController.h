//
//  WorkspacesController.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EncoderImagesToMovie;
@class WorkspaceFileListViewer;

@interface WorkspacesController : UIViewController <UIScrollViewDelegate> {
 
    BOOL updateInDidLoad;
    
    NSMutableArray *workspaces;
    
    IBOutlet UIScrollView *scrollView;
    
    EncoderImagesToMovie *encodeController;
    
    WorkspaceFileListViewer *fileViewerController;
}

- (void) movieCreatorOfWorkspace: (NSString*)name;
- (void) updateWorkspaces;

@end
