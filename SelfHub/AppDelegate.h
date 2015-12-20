//
//  AppDelegate.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"
#import "LoginViewController.h"
#import "UAirship.h"
#import "UAPush.h"

@class DesktopViewController;
@class InfoViewController;
@class ModuleProtocol;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) DesktopViewController *desktopViewController;
@property (nonatomic, assign) UIViewController *activeModuleViewController;

- (void)showSlideMenu;
- (void)updateMenuSliderImage;
- (void)hideSlideMenu;

- (void)performSuccessLogin;
- (void)performLogout;
- (void)performLogoutTwitter;


@end
