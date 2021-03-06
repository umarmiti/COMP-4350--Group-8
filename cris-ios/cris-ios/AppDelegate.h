//
//  AppDelegate.h
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-08.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    NSString *baseURL;
    NSString *curr_user;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSString *curr_user;

@end
