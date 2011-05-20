//
//  MyAVController.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@class  EncoderImagesToMovie;


/*!
 @class	AVController 

 @brief    Controller to demonstrate how we can have a direct access to the camera using the iPhone SDK 4
 */
@interface MyAVController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {
	AVCaptureSession *_captureSession;
	UIImageView *_imageView;
	CALayer *_customLayer;
	AVCaptureVideoPreviewLayer *_prevLayer;
    
    IBOutlet UISlider *slider;
    IBOutlet UILabel *counter;
    int imageCounter;
    
    EncoderImagesToMovie *encodeController;
}

/*!
 @brief	The capture session takes the input from the camera and capture it
 */
@property (nonatomic, retain) AVCaptureSession *captureSession;

/*!
 @brief	The UIImageView we use to display the image generated from the imageBuffer
 */
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
/*!
 @brief	The CALayer we use to display the CGImageRef generated from the imageBuffer
 */
@property (nonatomic, retain) CALayer *customLayer;
/*!
 @brief	The CALAyer customized by apple to display the video corresponding to a capture session
 */
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;

/*!
 @brief	This method initializes the capture session
 */
//- (void)initCapture;
- (IBAction)initCapture;

- (void) recreateCapture: (NSNumber*) numFrames;

- (IBAction) capture10;

- (IBAction) doneRecord;
//- (void) displayComposerSheet;

@end