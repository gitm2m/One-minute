//
//  Utils.m
//  Nova Universal Build
//
//  Created by Andrew Kopanev on 6/21/10.
//  Edited by Vladimir Boychentsov on 5/20/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation Utils

+ (BOOL) runningUnderiPad {
	NSString *modelName = [[UIDevice currentDevice] model];
	return [modelName rangeOfString: @"iPad"].location != NSNotFound;
}



+ (NSString *)getPlatform {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return platform;
}


+ (BOOL) iphone4 {
	NSString *platform = [Utils getPlatform];
	if ([platform isEqualToString:@"iPhone3,1"] ||
		[platform isEqualToString:@"iPhone3,3"]) return YES;
	return NO;
}


+ (NSString *) resourcesDirectory {
	static NSString* dPath = nil;
	
	if (!dPath) {
		dPath = [[NSBundle mainBundle] resourcePath];
		[dPath retain];
	}
	
	return dPath;
}


+ (NSString *) documentsDirectory {
	static NSString* dPath = nil;
	
	if (!dPath) {
		dPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
		[dPath retain];
	}
	
	return dPath;
}


+ (NSString *) cacheDirectory {
	static NSString* dPath = nil;
	
	if (!dPath) {
		dPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
		dPath = [dPath stringByAppendingPathComponent:@"inner_cache"];
		[dPath retain];
	}
	
	return dPath;	
}

+ (NSMutableArray *) shakeArray: (NSArray *) givenArray {
	NSMutableArray * array = [givenArray mutableCopy];
	NSMutableArray * shakedArray = [NSMutableArray arrayWithCapacity: array.count];
	
	while(array.count){
		int index = arc4random() % array.count;
		[shakedArray addObject: [array objectAtIndex: index]];
		[array removeObjectAtIndex:index];
	}
	
	return shakedArray;
}


+ (UIImage *)rotateImage:(UIImage *)image rotate:(UIImageOrientation)orientation {
	
	//int orient = image.imageOrientation;
	
	UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
	
	UIImage *imageCopy = [[[UIImage alloc] initWithCGImage:image.CGImage] autorelease];
	
	switch (orientation) {
		case UIImageOrientationLeft:
			imageView.transform = CGAffineTransformMakeRotation(3 * M_PI / 2.0);
			break;
		case UIImageOrientationRight:
			imageView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
			break;
		case UIImageOrientationDown: //EXIF = 3
			imageView.transform = CGAffineTransformMakeRotation(M_PI);
		default:
			break;
	}
	
	imageView.image = imageCopy;
	return (imageView.image);
}

// from to and between;
+ (BOOL) a:(float)a b:(float)b f:(float)from t:(float)to {
	if ((from < b && to > b) || (from < a && to > a) || (from < a+(b-a)*.5 && to > a+(b-a)*.5) ) {
		return YES;
	}
	return NO;
}


@end
