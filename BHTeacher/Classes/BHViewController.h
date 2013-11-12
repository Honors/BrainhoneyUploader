//
//  BHViewController.h
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFileUpload.h"

@interface BHViewController : UIViewController <UIWebViewDelegate, BHFileUploadDelegate> {
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    
    IBOutlet UIWebView *web;
    IBOutlet UIButton *submitButton;
    
    IBOutlet UITextView *statusBar;
    IBOutlet UILabel *fileStatus;
}
- (IBAction)fill;
- (IBAction)submitFile;
- (IBAction)goHome;
- (IBAction)refresh;
- (IBAction)parseLinks;
- (IBAction)goBack;
- (void)renderFile;
@end
