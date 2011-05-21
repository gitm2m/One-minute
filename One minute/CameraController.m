//
//  CameraController.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>

#import "CameraController.h"

@implementation CameraController

@synthesize captureSession = _captureSession;
@synthesize imageView = _imageView;
@synthesize customLayer = _customLayer;
@synthesize prevLayer = _prevLayer;



#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		/*We initialize some variables (they might be not initialized depending on what is commented or not)*/
		self.imageView = nil;
		self.prevLayer = nil;
		self.customLayer = nil;
        self.captureSession = nil;
        imageCounter = 0;
        intervalShot = 5;
        workspaceName = nil;
        nameWorkspaceField = nil;
	}
	return self;
}

- (IBAction) doneRecord {
    
    [self.captureSession stopRunning];
    
    [self.imageView setImage:nil];
    [sliderShot setHidden:NO];
    [countShot setHidden:NO];
    [startButton setHidden:NO];
    
    [doneButton setHidden:YES];
    
    [workspaceName release];
    workspaceName = nil;
    
    imageCounter = 0;
    [counter setText:@""];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) touchUpSliderShot {

    intervalShot = (int)sliderShot.value;
    [countShot setText:[NSString stringWithFormat:@"%d", intervalShot]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
}

- (void) viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
}


#pragma mark - save picture

- (void) saveCurrentPicture {
    [NSThread detachNewThreadSelector:@selector(saveCurrentPictureThread) toTarget:self withObject:nil];
}
- (void) saveCurrentPictureThread {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (![self.captureSession isRunning]) {
        [pool release];
        return;
    }
    
    
    UIImage *currentImage = [self.imageView image]; 
    NSData *imageData = UIImagePNGRepresentation(currentImage);
   
    NSString *filePath = [[Utils documentsDirectory] stringByAppendingFormat:@"/%@/frame_%d.png", workspaceName,imageCounter];
    
    [imageData writeToFile:filePath atomically:NO];
    imageCounter++;
    counter.text = [NSString stringWithFormat:@"Saved %d", imageCounter];

    
    [self performSelectorOnMainThread:@selector(nextTimer) withObject:nil waitUntilDone:YES];
    
    [pool release];
}


- (void) nextTimer {
    [NSTimer scheduledTimerWithTimeInterval:intervalShot target:self selector:@selector(saveCurrentPicture) userInfo:nil repeats:NO];
}


#pragma mark screen

- (void) startInit {
    
    [sliderShot setHidden:YES];
    [countShot setHidden:YES];
    [startButton setHidden:YES];
    
    [indicator setHidden:NO];
    [indicator startAnimating];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.captureSession != nil) {
        [self capture10];
        [self nextTimer];
    } else {
        [self performSelector:@selector(initCapture) withObject:nil afterDelay:0.5];
    }
}


- (IBAction) startCapture {
    
    
    if (workspaceName == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter workspace name:\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        if (nameWorkspaceField == nil) {
            nameWorkspaceField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 35.0, 245.0, 25.0)];//CGRectMake(40, 30, 200, 24)];
            [nameWorkspaceField setBorderStyle:UITextBorderStyleRoundedRect];
        } else {
            [nameWorkspaceField setText:@""];
        }
        [nameWorkspaceField setKeyboardAppearance:UIKeyboardTypeAlphabet];
        [nameWorkspaceField becomeFirstResponder];
        
        [alert addSubview:nameWorkspaceField];
        [alert show];
        [alert release];
    } else {
        [self startInit];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            if ([nameWorkspaceField.text length] > 1) {
                
                NSFileManager *manager = [NSFileManager defaultManager];
                NSString *documents = [Utils documentsDirectory];
                
                if ([manager fileExistsAtPath:[documents stringByAppendingPathComponent:nameWorkspaceField.text]]) {
                    [[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter another name..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
                    return;
                }
                
                [manager createDirectoryAtPath:[documents stringByAppendingPathComponent:nameWorkspaceField.text] withIntermediateDirectories:NO attributes:nil error:nil];
                
                workspaceName = [nameWorkspaceField.text retain];
                [self startInit];
            } else {
                [[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter workspace name..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
            }
        break;
    }
}




- (IBAction) initCapture {
    
    int frames = slider.value;
    
	/*We setup the input*/
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput 
										  deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] 
										  error:nil];
	/*We setupt the output*/
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	/*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
	 If you don't want this behaviour set the property to NO */
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 
	/*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
	 in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
	 In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
	 we are not able to process more than 10 frames per second.*/
	captureOutput.minFrameDuration = CMTimeMake(1, frames);
	
	/*We create a serial queue to handle the processing of our frames*/
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
	// Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[captureOutput setVideoSettings:videoSettings]; 
	/*And we create a capture session*/
	self.captureSession = [[AVCaptureSession alloc] init];
	/*We add input and output*/
	[self.captureSession addInput:captureInput];
	[self.captureSession addOutput:captureOutput];
    
    [captureOutput release];

    
    if ([Utils iphone4]) {
		[self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
	}
    
	/*We start the capture*/
	[self.captureSession startRunning];

	/*We add the Custom Layer (We need to change the orientation of the layer so that the video is displayed correctly)*/
	self.customLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
	
	self.customLayer.frame = self.view.layer.frame;
	//[self.view.layer addSublayer:self.customLayer];
	/*We add the imageView*/
    
    [doneButton setHidden:NO];
    [indicator stopAnimating];
    [indicator setHidden:YES];
    [NSTimer scheduledTimerWithTimeInterval:intervalShot target:self selector:@selector(saveCurrentPicture) userInfo:nil repeats:NO];

}



- (void) recreateCapture {
    
    int frames = slider.value;
    AVCaptureVideoDataOutput *captureOutput = [[self.captureSession outputs] lastObject];
    captureOutput.minFrameDuration = CMTimeMake(1, frames);
     if (![self.captureSession isRunning])
         [self.captureSession startRunning];
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [doneButton setHidden:NO];
}


- (IBAction) capture10 {
    if (self.captureSession == nil) {
        return;
    }
    [indicator setHidden:NO];
    [indicator startAnimating];
    [self performSelector:@selector(recreateCapture) withObject:nil afterDelay:0.15];
}



#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{ 
	/*We create an autorelease pool because as we are not in the main_queue our code is
	 not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
	
//	CGFloat angleInRadians = -90 * (M_PI / 180);
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0); 
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer);  
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//	CGContextRotateCTM(newContext, -angleInRadians);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
	
    /*We release some components*/
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);
    
    /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	//[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (id) newImage waitUntilDone:YES];
	
    
	/*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	 Same thing as for the CALayer we are not in the main thread so ...*/
	UIImage *image= [UIImage imageWithCGImage:newImage scale:1 orientation:UIImageOrientationDown];
	
//    + (UIImage *)imageWithCGImage:(CGImageRef)imageRef scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
    
    
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
	
	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
	[pool drain];
} 


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
   return NO;
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.imageView = nil;
	self.customLayer = nil;
	self.prevLayer = nil;
}

- (void)dealloc {
	
	[self.captureSession release];
    [super dealloc];
}


@end