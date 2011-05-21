//
//  One_minuteAppDelegate.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraController;


@interface One_minuteAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *_navController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end
