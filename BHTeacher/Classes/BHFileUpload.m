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
    return [[NSString stringWithFormat:@"%@/Editor/AssetHandler.ashx?entityid=%@&path=Assets/%@&mediatype=all&%@", prefix, entity, fname, cookie] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)entity {
    // TODO: domain specific, I believe
    return @"14915878";
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSArray *parts = [((NSHTTPURLResponse *)response).allHeaderFields[@"Set-Cookie"] componentsSeparatedByString:@";"];
    [self.delegate gotCookie:[parts firstObject]];
}
- (void)getCookieForUser: (NSString *)username withPass: (NSString *)password {
    id devswitch = [[NSUserDefaults standardUserDefaults] valueForKey:@"devswitch"];
    NSString *prefix = [devswitch intValue] ? @"https://bwhst.brainhoney.com" : @"https://bwhs.brainhoney.com";
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Controls/CredentialsUI.ashx", prefix]]];
    NSString *post = [NSString stringWithFormat:@"action=login&ReturnUrl=https%%3A%%2F%%2Fbwhst.brainhoney.com%%2FFrame%%2FComponent%%2FHome&standardOffset=300&daylightOffset=240&standardStartTime=2013-11-03T06%%3A00%%3A00Z&daylightStartTime=2013-03-10T07%%3A00%%3A00Z&username=%@&password=%@", username, password];
    [req setHTTPBody:[post dataUsingEncoding:NSStringEncodingConversionAllowLossy]];
    [req setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
}
- (void)uploadForTeacher: (NSString *)cookie andEntity: (NSString *)entity {
    // prepare cached file
    NSURL *file = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"]];
    NSString *fname = [[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"] lastPathComponent];
    
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
        [self.delegate uploaded];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
