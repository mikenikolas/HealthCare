//
//  WeightControlDataCell.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"

@interface WeightControlDataCell : UITableViewCell{
    
}

@property (nonatomic, retain) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *weightLabel;
@property (nonatomic, retain) IBOutlet UILabel *trendTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *trendLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviationTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviationLabel;

@property (nonatomic, retain) IBOutlet ButtonWithLabel *addButton;
@property (nonatomic, retain) IBOutlet ButtonWithLabel *editButton;
@property (nonatomic, retain) IBOutlet ButtonWithLabel *removeButton;
@property (nonatomic, retain) IBOutlet UILabel *recordsLabel;

- (IBAction)pressButton:(id)sender;

@end
