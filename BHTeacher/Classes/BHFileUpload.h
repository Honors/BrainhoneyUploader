//
//  BHFileUpload.h
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BHFileUploadDelegate <NSObject>
- (void)uploadSucceeded: (BOOL)success;
@end

@interface BHFileUpload : NSObject
- (void)uploadForTeacher: (NSString *)cookie;
@property id<BHFileUploadDelegate> delegate;
@end