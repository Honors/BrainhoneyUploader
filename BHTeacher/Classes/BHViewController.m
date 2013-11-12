//
//  BHViewController.m
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "BHViewController.h"

@interface BHViewController () {
    BOOL foundAssn;
    NSString *currentClass;
    NSString *currentItem;
    NSString *currentCookie;
}

@end

@implementation BHViewController

- (void)renderFile {
    // render the file-cache view and status bar based on the presence of a cached file
    NSString *file = [[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"];
    if( file != nil ) {
        statusBar.text = @"The file to the left has been cached. Navigate to a course page then press \"Submit File\" to upload.";
        fileStatus.text = file.lastPathComponent;
    } else {
        statusBar.text = @"In order to upload a file, press \"Open with Brainhoney\" from another app, usually through an export button.";
    }
}
- (void)uploadedSuccessfully: (BOOL)success {
    // render a status message based on the upload's success
    statusBar.text = success ? @"The file was uploaded successfully." : @"The file upload failed.";
}
- (IBAction)refresh {
    [web reload];
}
- (IBAction)parseLinks {
    NSArray *links = [[web stringByEvaluatingJavaScriptFromString:@"[].map.call(document.querySelectorAll('[href*=Dropbox]'), function(x){return x.outerHTML}).join('$$')"] componentsSeparatedByString:@"$$"];
    [web loadHTMLString:[links componentsJoinedByString:@"<br>"] baseURL:[NSURL URLWithString:web.request.URL.absoluteString]];
}
- (IBAction)goBack {
    [web goBack];
}
- (IBAction)fill {
    // fill the login form within the webview and submit it
    [[NSUserDefaults standardUserDefaults] setValue:username.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:password.text forKey:@"password"];
    [web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'; document.querySelector('input[name=password]').value = '%@'; Login();", username.text, password.text]];
    [self renderFile];
    
    BHFileUpload *uploader = [BHFileUpload alloc];
    uploader.delegate = self;
    [uploader getCookieForUser:username.text withPass:password.text];
}
- (IBAction)submitFile {
    // allocate an uploader and provide it with the assignment meta-data
    BHFileUpload *uploader = [BHFileUpload alloc];
    uploader.delegate = self;
    [uploader uploadForTeacher:currentCookie andEntity:currentItem];
}
- (IBAction)goHome {
    // send the webview to its initial view
    id devswitch = [[NSUserDefaults standardUserDefaults] valueForKey:@"devswitch"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[devswitch intValue] ? @"https://bwhst.brainhoney.com" : @"https://bwhs.brainhoney.com"]];
    [web loadRequest:request];
}
- (NSDictionary *)parseQuery: (NSString *)filename {
    // a simple GET query string parser
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:255];
    NSArray *vars = [[filename componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
    for( NSString *var in vars ) {
        NSArray *parts = [var componentsSeparatedByString:@"="];
        if( parts.count > 1 ) {
            dict[parts[0]] = parts[1];
        }
    }
    return dict;
}
- (void)gotCookie: (NSString *)cookie {
    currentCookie = cookie;
    submitButton.enabled = YES;
    foundAssn = YES;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = ((NSHTTPURLResponse *)request).URL.absoluteString;
    if( [url componentsSeparatedByString:@"enrollment"].count > 1 ) {
        statusBar.text = @"A course has been selected. Press \"Submit File\" to finish the upload process.";
        currentItem = [self parseQuery:url][@"enrollmentid"];
        currentItem = [[currentItem componentsSeparatedByString:@"."] firstObject];
    }
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // set assignment as not yet specified
    foundAssn = NO;
    
    // load an initial view, depending on the user's settings
    // and listen to requests in the webview
    web.delegate = self;
    [self goHome];
    
    // provide styling for the `Submit File` button
    [submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [submitButton setTitleColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
    
    // load username and password from last login
    username.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    password.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    // render the file-cache view
    [self renderFile];
}

@end
