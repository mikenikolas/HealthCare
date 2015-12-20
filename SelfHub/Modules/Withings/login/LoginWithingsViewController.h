//
//  LoginWithingsViewController.h
//  SelfHub
//
//  Created by ET on 10.10.12.
//
//

#import <UIKit/UIKit.h>
#import "Withings.h"
#import "WorkWithWithings.h"
#import "SelectUserView/WithingsCustomCell.h"

@class Withings;
@interface LoginWithingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>{
    NSArray *Userlist;
}

@property (nonatomic, assign) Withings *delegate;

@property (retain, nonatomic) IBOutlet UIButton *loginButton;

@property (retain, nonatomic) IBOutlet UILabel *passwordLabel;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;

@property (retain, nonatomic) IBOutlet UIImageView *actView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UILabel *actLabel;

@property (retain, nonatomic) IBOutlet UILabel *loginLabel;
@property (retain, nonatomic) IBOutlet UITextField *loginTextField;
@property (retain, nonatomic) IBOutlet UIControl *mainLoginView;
@property (retain, nonatomic) IBOutlet UITableView *usersTableView;
@property (retain, nonatomic) IBOutlet UIView *mainSelectionUserView;
@property (retain, nonatomic) IBOutlet UIView *mainHostLoginView;
@property (retain, nonatomic) IBOutlet UILabel *ErrorLabel;
@property (retain, nonatomic) IBOutlet UILabel *singInLabel;


- (IBAction)backgroundTouched:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)registrButtonClick:(id)sender;
- (void)cleanup;
- (void) clickCellImportButton:(int) senders;
- (void)synchNotificationShouldOn:(UISwitch*) pushSwitch;
- (void)synchNotificationShouldOff: (UISwitch *)pushSwitch;

@end
