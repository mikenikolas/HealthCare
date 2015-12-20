//
//  WeightControl.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"
#import "WeightControlChart.h"
#import "WeightControlData.h"
#import "WeightControlStatistics.h"
#import "WeightControlSettings.h"
#import "ModuleTableCell.h"
#import "MainInformation.h"

@class WeightControlGraphView;
    
@interface WeightControl : UIViewController <ModuleProtocol, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *weightData;
    NSNumber *aimWeight;
    NSNumber *normalWeight;
    
    UIImage *tutorialBackgroundImage1;
    UIImage *tutorialBackgroundImage2;
    
    NSArray *modulePagesArray;
    NSIndexPath *lastSelectedIndexPath;
};

@property (nonatomic, assign) id <ServerProtocol> delegate;

@property (nonatomic) BOOL isShowNormLine;

@property (nonatomic, retain) IBOutlet UITableView *rightSlideBarTable;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIView *moduleView;
@property (nonatomic, retain) IBOutlet UIView *slidingMenu;
@property (nonatomic, retain) IBOutlet UIImageView *slidingImageView;

@property (nonatomic, retain) NSMutableArray *weightData;
@property (nonatomic, retain) NSNumber *aimWeight;
@property (nonatomic, retain) NSNumber *normalWeight;

@property (nonatomic, retain) NSArray *modulePagesArray;
@property (nonatomic, retain) IBOutlet UIView *hostView;

@property (nonatomic, retain) UIButton *tutorialButton;


- (NSString *)getBaseDir;

- (void)fillTestData:(NSUInteger)numOfElements;
- (void)generateNormalWeight;
- (void)updateTrendsFromIndex:(NSUInteger)startIndex;


- (NSString *)getWeightUnit;
- (NSString *)getHeightUnit;
- (float)getWeightKoef;
- (float)getHeightKoef;
- (NSString *)getWeightStrForWeightInKg:(float)kgWeight withUnit:(BOOL)isUnit;
- (NSString *)getHeightStrForHeightInCm:(float)cmHeight withUnit:(BOOL)isUnit;

- (float)getBMI;

- (NSTimeInterval)getTimeIntervalToAim;
- (float)getForecastTrendForWeek;

- (NSDate *)getDateWithoutTime:(NSDate *)_myDate;
- (NSComparisonResult)compareDateByDays:(NSDate *)_firstDate WithDate:(NSDate *)_secondDate;
- (void)sortWeightData;
- (void)normalizeWeightData; // Remove time from date & remove identical records

- (IBAction)showSlidingMenu:(id)sender;
- (IBAction)hideSlidingMenu:(id)sender;

- (IBAction)showTutorial:(id)sender;

- (NSInteger)getCurrentPage;

@end
