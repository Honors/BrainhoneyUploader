//
//  BHFileUpload.m
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "BHFileUpload.h"
#import "AFNetworking.h"

@implementation BHFileUpload
- (void)uploadForStudent: (NSString *)cookie inClass: (NSString *)enrollment forItem: (NSString *)itemid {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"enrollmentid": enrollment, @"actiontype": @"submit", @"itemid": itemid};
    
    NSURL *file = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"]];
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [manager POST:@"https://bwhst.brainhoney.com/Content/Assignment.ashx" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:file name:@"attachment" error:nil];
    } success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
        [self.delegate uploadSucceeded:[responseObject isEqualToString:@"success"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
