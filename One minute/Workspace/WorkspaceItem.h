//
//  WorkspaceItem.h
//  One minute
//
//  Created by Vladimir Boychentsov on 5/21/11.
//  Copyright 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkspaceItem : UIView {
 
    NSString *title;
    UILabel *labelName;
    id delegate;
}
@property (assign) id delegate;
- (void) setTitleName: (NSString*) _title;

@end
