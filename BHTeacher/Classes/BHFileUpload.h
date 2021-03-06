//
//  BHFileUpload.h
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BHFileUploadDelegate <NSObject>
- (void)uploadedSuccessfully: (BOOL)success;
- (void)gotCookie: (NSString *)cookie;
@end

@interface BHFileUpload : NSObject <NSURLConnectionDelegate> {
    NSMutableData *cookieData;
}

- (void)getCookieForUser: (NSString *)username withPass: (NSString *)password;
- (void)uploadForTeacher: (NSString *)cookie andEntity: (NSString *)entity;
@property id<BHFileUploadDelegate> delegate;
@end