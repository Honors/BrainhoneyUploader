//
//  BHAppDelegate.m
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "BHAppDelegate.h"
#import "BHViewController.h"

@implementation BHAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[NSUserDefaults standardUserDefaults] setValue:url.path forKey:@"file_url"];
    [(BHViewController *)self.window.rootViewController renderFile];
    return YES;
}


@end
