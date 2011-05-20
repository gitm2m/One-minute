//
//  One_minuteAppDelegate.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAVController;


@interface One_minuteAppDelegate : NSObject <UIApplicationDelegate> {

    MyAVController *cameraController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
