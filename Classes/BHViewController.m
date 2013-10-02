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
    NSString *file = [[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"];
    if( file != nil ) {
        statusBar.text = @"The file to the left has been cached. Navigate to an assignment then press \"Submit File\" to upload.";
        fileStatus.text = file.lastPathComponent;
    } else {
        statusBar.text = @"In order to upload a file, press \"Open with Brainhoney\" from another app, usually through an export button.";
    }
}
- (void)uploadSucceeded:(BOOL)success {
    statusBar.text = success ?
        @"The file was uploaded successfully." :
        @"The upload failed. Has a file already been submitted?";
}
- (IBAction)fill {
    [[NSUserDefaults standardUserDefaults] setValue:username.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:password.text forKey:@"password"];
    NSLog(@"setting values");
    [web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'; document.querySelector('input[name=password]').value = '%@'; Login();", username.text, password.text]];
    [self renderFile];
}
- (IBAction)submitFile {
    BHFileUpload *uploader = [BHFileUpload alloc];
    uploader.delegate = self;
    [uploader uploadForStudent:currentCookie inClass:currentClass forItem:currentItem];
}
- (NSDictionary *)parseQuery: (NSString *)filename {
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if( [url componentsSeparatedByString:@"&itemid="].count > 1 ) {
        submitButton.enabled = YES;
        NSString *query = [url componentsSeparatedByString:@"?"][1];
        foundAssn = YES;
        currentClass = [self parseQuery:query][@"enrollmentid"];
        currentItem = [self parseQuery:query][@"itemid"];
        currentCookie = request.allHTTPHeaderFields[@"Cookie"];
    }
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    foundAssn = NO;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://bwhst.brainhoney.com"]];
    web.delegate = self;
    [web loadRequest:request];
    
    [submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [submitButton setTitleColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
    
    username.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    password.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    [self renderFile];
}

@end
