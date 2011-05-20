//
//  EncoderImagesToMovie.m
//  One minute
//
//  Created by Vladimir Boychentsov on 5/20/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import "Utils.h"

#import "EncoderImagesToMovie.h"

#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>


NSInteger sort(id a, id b, void *reverse) {
    return [a 
            compare:b
            options:NSNumericSearch];
}




@implementation EncoderImagesToMovie

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                        CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (CFDictionaryRef) options, 
                        &pxbuffer);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace, 
                                                 kCGImageAlphaNoneSkipFirst);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    
    CGAffineTransform flipVertical = CGAffineTransformMake(
                                                           1, 0, 0, -1, 0, CGImageGetHeight(image)
                                                           );
    CGContextConcatCTM(context, flipVertical); 
    
    
    
    CGAffineTransform flipHorizontal = CGAffineTransformMake(
                                                             -1.0, 0.0, 0.0, 1.0, CGImageGetWidth(image), 0.0
                                                             );
    
    CGContextConcatCTM(context, flipHorizontal); 
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), 
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}



- (void )writeImagesAsMovie:(NSArray *)array toPath:(NSString*)path {
    
    NSString *documents = [Utils documentsDirectory];
    
    //NSLog(path);
    NSString *filename = [documents stringByAppendingPathComponent:[array objectAtIndex:0]];
    UIImage *first = [UIImage imageWithContentsOfFile:filename];
    
    
    CGSize frameSize = first.size;
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:path] fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    
    if(error) {
        NSLog(@"error creating AssetWriter: %@",[error description]);
    }
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:frameSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:frameSize.height], AVVideoHeightKey,
                                   nil];
    
    
    
    AVAssetWriterInput* writerInput = [[AVAssetWriterInput
                                        assetWriterInputWithMediaType:AVMediaTypeVideo
                                        outputSettings:videoSettings] retain];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.width] forKey:(NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.height] forKey:(NSString*)kCVPixelBufferHeightKey];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     sourcePixelBufferAttributes:attributes];
    
    [videoWriter addInput:writerInput];
    
    // fixes all errors
    writerInput.expectsMediaDataInRealTime = YES;
    
    //Start a session:
    BOOL start = [videoWriter startWriting];
    NSLog(@"Session started? %d", start);
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    buffer = [self pixelBufferFromCGImage:[first CGImage]];
    BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    
    if (result == NO) //failes on 3GS, but works on iphone 4
        NSLog(@"failed to append buffer");
    
    if(buffer)
        CVBufferRelease(buffer);
    
    [NSThread sleepForTimeInterval:0.05];
    //for (int i = 1;i<[array count]; i++)
    //    
    int reverseSort = NO;
    NSArray *newArray = [array sortedArrayUsingFunction:sort context:&reverseSort];
    
    
    //    NSArray *newArray = [array sortedArrayUsingComparator:^(NSString* a, NSString* b) { 
    //        return [a compare:b options:NSNumericSearch]; 
    //    }];
    
    
    delta = 1.0/[newArray count];
    
    int i = 0;
    for (NSString *filename in newArray)
    {
        if (adaptor.assetWriterInput.readyForMoreMediaData) 
        {
            
            i++;
            NSLog(@"inside for loop %d %@ ",i, filename);
            CMTime frameTime = CMTimeMake(1, 15);
            CMTime lastTime=CMTimeMake(i, 15); 
            CMTime presentTime=CMTimeAdd(lastTime, frameTime);
            
            NSString *filePath = [documents stringByAppendingPathComponent:filename];
            
            //            NSString *imgName = [NSString stringWithFormat:@"frame%d.png",i];
            UIImage *imgFrame = [UIImage imageWithContentsOfFile:filePath] ;
            buffer = [self pixelBufferFromCGImage:[imgFrame CGImage]];
            BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
            
            if (result == NO) //failes on 3GS, but works on iphone 4
            {
                NSLog(@"failed to append buffer");
                NSLog(@"The error is %@", [videoWriter error]);
            }
            if(buffer)
                CVBufferRelease(buffer);
            [NSThread sleepForTimeInterval:0.05];
        }
        else
        {
            NSLog(@"error");
            i--;
        }
        [self performSelectorOnMainThread:@selector(addprogress) withObject:nil waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.02];
    }
    
    //Finish the session:
    [writerInput markAsFinished];
    [videoWriter finishWriting];
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
    [videoWriter release];
    [writerInput release];
    
    NSLog(@"Movie created successfully");
    
    [self performSelectorOnMainThread:@selector(displaySheet) withObject:nil waitUntilDone:YES];
    
    
    
}


- (void) addprogress {
    progressView.progress += delta;
}


- (void) displaySheet {
    [self.view setUserInteractionEnabled:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Send by Mail" otherButtonTitles:@"Save to Album", nil];
    [sheet showInView:self.view];
    [sheet autorelease];
}



- (IBAction) createMovie {
    
    progressView.progress = 0;
    [self.view setUserInteractionEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(createMovieTh) toTarget:self withObject:nil];
    
}

- (void) createMovieTh {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documents = [Utils documentsDirectory];
    
    [manager removeItemAtPath:[documents stringByAppendingPathComponent:@"movie.mov"] error:nil];
    
    NSArray *files = [manager contentsOfDirectoryAtPath:documents error:nil];
    [self writeImagesAsMovie:files toPath:[documents stringByAppendingPathComponent:@"movie.mov"]];
    [pool release];
}





#pragma mark-
#pragma mark MFMailComposer 

- (void) displayComposerSheet {
	
    
    
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
		mailPicker.mailComposeDelegate = self;		
		[mailPicker setMessageBody: @"Movie" isHTML: YES];
		

        NSURL    *fileURL = [[NSURL alloc] initFileURLWithPath:[[Utils documentsDirectory] stringByAppendingPathComponent:@"movie.mov"]];
        NSData *soundFile = [[NSData alloc] initWithContentsOfURL:fileURL];
        [mailPicker addAttachmentData:soundFile mimeType:@"mov/mpeg" fileName:@"movie.mov"];
		
		[self presentModalViewController: mailPicker animated: YES];
		[mailPicker release];	
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"E-Mail", "")
														message: NSLocalizedString(@"Please, setup your mail account first.", "")
													   delegate: nil
											  cancelButtonTitle: @"OK"
											  otherButtonTitles: nil]; 
		[alert show];
		[alert release];	
		return;
	}
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error  {
    
	if (result ==  MFMailComposeResultFailed || result ==  MFMailComposeResultSent) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
														message: ((result ==  MFMailComposeResultSent)
                                                                  ? NSLocalizedString(@"Your message has been successfully sent.", "") 
                                                                  : NSLocalizedString(@"Unable to send your message.", ""))
													   delegate: nil
											  cancelButtonTitle: @"OK"
											  otherButtonTitles: nil]; 
		[alert show];
		[alert release];
        
        [controller dismissModalViewControllerAnimated: YES];
        [self dismissModalViewControllerAnimated:YES];
	} else {
        [controller dismissModalViewControllerAnimated: YES];
	}
}


#pragma mark save to librarry

- (void) saveToMediaLibrary {
    NSString *documents = [Utils documentsDirectory];
    
    UISaveVideoAtPathToSavedPhotosAlbum([documents stringByAppendingPathComponent:@"movie.mov"],
                                        self,
                                        @selector(video:didFinishSavingWithError:contextInfo:),
                                        nil);
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image/video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    NSLog(@"dismiss");
    [self dismissModalViewControllerAnimated:YES];
}





- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self displayComposerSheet];
            break;
            
        case 1:
            [self saveToMediaLibrary];
            break;
    }
    
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
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
