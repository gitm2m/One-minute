//
//  MainMenuController.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EncoderImagesToMovie;
@class CameraController;
@class WorkspacesController;

@interface MainMenuController : UIViewController {
    EncoderImagesToMovie *encodeController;
    CameraController *cameraController;
    WorkspacesController *workspacesController;
}

- (IBAction) camera;
- (IBAction) movieCreator;
- (IBAction) workspace;

@end
