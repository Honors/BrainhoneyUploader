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
- (NSString *)endpointForEntity: (NSString *)entity withCookie: (NSString *)cookie andFileName: (NSString *)fname  {
    // based on a user's settings, the endpoint to which to upload
    id devswitch = [[NSUserDefaults standardUserDefaults] valueForKey:@"devswitch"];
    NSString *prefix = [devswitch intValue] ? @"https://bwhst.brainhoney.com" : @"https://bwhs.brainhoney.com";
    NSLog(@"prefix: %@", prefix);
    return [NSString stringWithFormat:@"%@/Editor/AssetHandler.ashx?entityid=%@&path=Assets/%@&mediatype=all&.ASPXAUTH=%@", prefix, entity, fname, cookie];
}
- (NSString *)entity {
    // TODO: domain specific, I believe
    return @"14915878";
}
- (void)uploadForTeacher: (NSString *)cookie {
    // prepare cached file
    NSURL *file = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"]];
    NSString *fname = [[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"] lastPathComponent];
    NSString *entity = [self entity];
    
    // allocate a request manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // set headers
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    // define parameters
    NSDictionary *parameters = @{@"__VIEWSTATE": @"/wEPDwUINTIxODU1MzhkZKgW5U0d/kbIvCytxYMA4Y4pbuCZ"};
    
    // send the POST request
    NSString *endpoint = [self endpointForEntity:entity withCookie:cookie andFileName:fname];
    NSLog(@"EP: %@", endpoint);
    [manager POST:endpoint parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // attach the file
        [formData appendPartWithFileURL:file name:@"up_file" error:nil];
    } success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
        [self.delegate uploadSucceeded:[responseObject isEqualToString:@"success"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
