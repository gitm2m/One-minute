//
//  EncoderImagesToMovie.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EncoderImagesToMovie : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UIProgressView *progressView;
    float delta;
}
- (IBAction) createMovie;


- (void) writeImagesAsMovie:(NSArray *)array toPath:(NSString*)path;


@end
