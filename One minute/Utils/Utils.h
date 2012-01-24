//
//  Utils.h
//  Nova Universal Build
//
//  Created by Andrew Kopanev on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Utils : NSObject {

}
+ (BOOL) runningUnderiPad;
+ (NSString *) resourcesDirectory;
+ (NSString *) documentsDirectory;
+ (NSString *) cacheDirectory;
+ (NSMutableArray *) shakeArray: (NSArray *) givenArray;

+ (UIImage *)rotateImage:(UIImage *)image rotate:(UIImageOrientation)orientation;

+ (BOOL) iphone4;
+ (NSString *)getPlatform;

+ (BOOL) a:(float)a b:(float)b f:(float)from t:(float)to;


@end
