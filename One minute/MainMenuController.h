//
//  MainMenuController.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraController;
@class WorkspacesController;

@interface MainMenuController : UIViewController {
    CameraController *cameraController;
    WorkspacesController *workspacesController;
}

- (IBAction) camera;
- (IBAction) workspace;

@end
