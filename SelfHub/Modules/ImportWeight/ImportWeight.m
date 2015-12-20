//
//  ImportWeight.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 13.11.12.
//
//

#import "ImportWeight.h"
#import "Flurry.h"

@interface ImportWeight ()

@end

@implementation ImportWeight

@synthesize delegate, modulePagesArray;
@synthesize rightSlideBarTable, navBar, hostView, moduleView, slidingMenu, slidingImageView;
@synthesize tutorialButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Creating navigation bar with buttons. Use only standart elements
    self.navBar.topItem.title = [self getModuleName];
    
    modulePagesArray = [[NSMutableArray alloc] init];
    ImportWeightFromITunes *importFromITunesViewController = [[ImportWeightFromITunes alloc] initWithNibName:@"ImportWeightFromITunes" bundle:nil];
    importFromITunesViewController.delegate = self;
    [modulePagesArray addObject:importFromITunesViewController];
    [importFromITunesViewController release];
    
    [hostView addSubview:((UIViewController *)[modulePagesArray objectAtIndex:0]).view];
    lastSelectedIndexPath = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
    
    UIImageView *darkPathImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DesktopVerticalDarkRightPath.png"]];
    float verticalPathHeight = [UIScreen mainScreen].bounds.size.height;
    darkPathImage.frame = CGRectMake(self.view.frame.size.width, 0, darkPathImage.frame.size.width, verticalPathHeight);
    darkPathImage.userInteractionEnabled = NO;
    [slidingImageView addSubview:darkPathImage];
    [darkPathImage release];
    
    
    UIImage *navBarBackgroundImage = [UIImage imageNamed:@"DesktopNavBarBackground.png"];
    [self.navBar setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 42.0, 32.0);
    [leftBarBtn setImage:[UIImage imageNamed:@"DesktopSlideLeftNavBarButton.png"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"DesktopSlideLeftNavBarButton_press.png"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(pressMainMenuButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navBar.topItem.leftBarButtonItem = leftBarButtonItem;
    [leftBarButtonItem release];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 42.0, 32.0);
    [rightBarBtn setImage:[UIImage imageNamed:@"DesktopSlideRightNavBarButton.png"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"DesktopSlideRightNavBarButton_press.png"] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(showSlidingMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navBar.topItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    
    //slideing-out navigation support
    slidingImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreenshot:)];
    [slidingImageView addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveScreenshot:)];
    [panGesture setMaximumNumberOfTouches:2];
    [slidingImageView addGestureRecognizer:panGesture];
    [tapGesture release];
    [panGesture release];
    
    // tutorial elements
    float tutorialButtonOriginX = (self.view.bounds.size.width/2.0) + ([self.navBar.topItem.title sizeWithFont:[UIFont boldSystemFontOfSize:18.0]].width/2.0) + 5.0;
    tutorialButton = [[UIButton alloc] initWithFrame:CGRectMake(tutorialButtonOriginX, 6.0, 32.0, 32.0)];
    [tutorialButton setImage:[UIImage imageNamed:@"DesktopNavBar_tutorialBtn_norm.png"] forState:UIControlStateNormal];
    [tutorialButton setImage:[UIImage imageNamed:@"DesktopNavBar_tutorialBtn_press.png"] forState:UIControlStateHighlighted];
    [tutorialButton addTarget:self action:@selector(showTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:tutorialButton];
    
    NSString *imagePath1 = ([delegate isRetina4] ? @"weightImportITunes_tutorialBackground-568@2x" : @"weightImportITunes_tutorialBackground@2x");
    tutorialBackgroundImage1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imagePath1 ofType:@"png"]];
};

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIView *currentView = [[modulePagesArray objectAtIndex:[lastSelectedIndexPath row]] view];
    if(currentView.superview != hostView){
        [self.hostView addSubview:currentView];
    };
    
    [Flurry logEvent:@"ImportWeight.open"];
};


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    delegate = nil;
    if(modulePagesArray) [modulePagesArray release];
    [rightSlideBarTable release];
    [navBar release];
    [hostView release];
    [moduleView release];
    [slidingMenu release];
    [slidingImageView release];
    
    if(lastSelectedIndexPath) [lastSelectedIndexPath release];
    
    if(tutorialBackgroundImage1) [tutorialBackgroundImage1 release];
    
    
    [super dealloc];
};

- (NSInteger)numOfRecordsFromFileAsCVS:(NSString *)filePath{
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSNonLossyASCIIStringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    NSArray *dividedRec;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSDate *curDate;
    float curWeight;
    
    NSInteger res = 0;
    for(NSString *oneRec in arr){
        dividedRec = [oneRec componentsSeparatedByString:@";"];
        if([dividedRec count]<2) continue;
        
        curDate = [[dateFormatter dateFromString:[dividedRec objectAtIndex:0]] retain];
        if(curDate==nil) continue;
        [curDate release];
        
        curWeight = [[dividedRec objectAtIndex:1] floatValue];
        if(curWeight<=0.0) continue;
        
        res++;
    };
    [dateFormatter release];
    
    return res;
};

- (NSArray *)recordsFromFileAsCVS:(NSString *)filePath{
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSNonLossyASCIIStringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    NSArray *dividedRec;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *curDate;
    float curWeight;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *oneResultDict;
    for(NSString *oneRec in arr){
        //NSLog(@"%@", oneRec);
        dividedRec = [oneRec componentsSeparatedByString:@";"];
        if([dividedRec count]<2) continue;
        curDate = [[dateFormatter dateFromString:[dividedRec objectAtIndex:0]] retain];
        if(curDate==nil) continue;
        curWeight = [[dividedRec objectAtIndex:1] floatValue];
        if(curWeight<=0.0){
            [curDate release];
            continue;
        };
        
        oneResultDict = [[NSMutableDictionary alloc] init];
        [oneResultDict setObject:curDate forKey:@"date"];
        [oneResultDict setObject:[NSNumber numberWithFloat:curWeight] forKey:@"weight"];
        [resultArray addObject:oneResultDict];
        
        //NSLog(@"%@ -> %.1f", [[oneResultDict objectForKey:@"date"] description], [[oneResultDict objectForKey:@"weight"] floatValue]);
        [curDate release];
        [oneResultDict release];
    };
    [dateFormatter release];
    
    NSArray *res = [NSArray arrayWithArray:resultArray];
    [resultArray release];
    
    return res;
};


- (void)addRecordsToBase:(NSArray *)newRecords{
    NSMutableArray *weightModuleData = (NSMutableArray*)[delegate getValueForName:@"database" fromModuleWithID:@"selfhub.weight"];
    for(NSDictionary *curRec in newRecords){
        NSDate *curDate = [curRec objectForKey:@"date"];
        NSNumber *curWeight = [curRec objectForKey:@"weight"];
        NSLog(@"date: %@, weight: %.1f", [curDate description], [curWeight floatValue]);
        [weightModuleData addObject:curRec];
    };
    [delegate setValue:weightModuleData forName:@"database" forModuleWithID:@"selfhub.weight"];
    
    [Flurry logEvent:@"ImportWeight.import_records" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[newRecords count]] forKey:@"count"]];
};

- (void)clearBaseAndAddRecords:(NSArray *)newRecords{
    NSMutableArray *weightModuleData = (NSMutableArray*)[delegate getValueForName:@"database" fromModuleWithID:@"selfhub.weight"];
    [weightModuleData removeAllObjects];
    for(NSDictionary *curRec in newRecords){
        NSDate *curDate = [curRec objectForKey:@"date"];
        NSNumber *curWeight = [curRec objectForKey:@"weight"];
        NSLog(@"date: %@, weight: %.1f", [curDate description], [curWeight floatValue]);
        [weightModuleData addObject:curRec];
    };
    [delegate setValue:weightModuleData forName:@"database" forModuleWithID:@"selfhub.weight"];
    
    [Flurry logEvent:@"ImportWeight.clear_and_import_records" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[newRecords count]] forKey:@"count"]];
};

            

#pragma mark - Right sliding menu functions

- (IBAction)showSlidingMenu:(id)sender{
    CGSize viewSize = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 2.0);
    [self.moduleView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    slidingImageView.image = image;
    
    self.view = slidingMenu;
    
    [rightSlideBarTable selectRowAtIndexPath:lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    slidingImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slidingImageView setFrame:CGRectMake(-130, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished){
        
    }];
};

- (IBAction)hideSlidingMenu:(id)sender{
    CGSize viewSize = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 2.0);
    [self.moduleView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    slidingImageView.image = image;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slidingImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished){
        self.view = moduleView;
    }];
};

-(void)moveScreenshot:(UIPanGestureRecognizer *)gesture
{
    UIView *piece = [gesture view];
    //[self adjustAnchorPointForGestureRecognizer:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:[piece superview]];
        
        // I edited this line so that the image view cannont move vertically
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y)];
        [gesture setTranslation:CGPointZero inView:[piece superview]];
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded)
        [self hideSlidingMenu:nil];
}

- (void)tapScreenshot:(UITapGestureRecognizer *)gesture{
    [self hideSlidingMenu:nil];
};

#pragma mark - Module's tutorial supporting

- (IBAction)showTutorial:(id)sender{
    UIView *tutorialView = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *myLabel;
    
    if([lastSelectedIndexPath row]==0){
        UIImageView *tutorialBackground = [[UIImageView alloc] initWithImage:tutorialBackgroundImage1];
        [tutorialView addSubview:tutorialBackground];
        [tutorialBackground release];
        
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 66.0, 125.0, 20.0)];
        myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.textAlignment = NSTextAlignmentLeft;
        myLabel.text = NSLocalizedString(@"Module selection", @"");
        [tutorialView addSubview:myLabel];
        [myLabel release];
        
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 94.0, 130.0, 20.0)];
        myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.textAlignment = NSTextAlignmentRight;
        myLabel.text = NSLocalizedString(@"Module's pages", @"");
        float modulesPagesTitleWidth = [myLabel.text sizeWithFont:myLabel.font].width;
        [tutorialView addSubview:myLabel];
        [myLabel release];
        
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0 - (70.0-modulesPagesTitleWidth)-15.0, 114.0, 150.0, 40.0)];
        myLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.textAlignment = NSTextAlignmentLeft;
        myLabel.numberOfLines = 2;
        myLabel.text = NSLocalizedString(@"Select the import source", @"");
        [tutorialView addSubview:myLabel];
        [myLabel release];
        
        [delegate showTutorial:tutorialView];
    };
    
    [tutorialView release];
};


#pragma mark - TableView delegate (supporting right table-based navigation)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
};

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
};

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect headerRect = CGRectMake(0.0, 0.0, tableView.bounds.size.width, 20.0);
    
    UIView *headerView = [[[UIView alloc] initWithFrame:headerRect] autorelease];
    
    UIImageView *headerBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DesktopCellHeaderBackground.png"]];
    headerBackgroundImage.alpha = 0.3;
    [headerView addSubview:headerBackgroundImage];
    [headerBackgroundImage release];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 2.0, 140.0, 16.0)];
    headerLabel.textColor = [UIColor lightTextColor];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.text = NSLocalizedString(@"Import sources", @"");
    
    [headerView addSubview:headerLabel];
    [headerLabel release];
    
    return headerView;
};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID;
    cellID = @"RightSlideMenuTableCell";
    
    ModuleTableCell *cell = (ModuleTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ModuleTableCell" owner:self options:nil];
        for(id oneObject in nibs){
            if([oneObject isKindOfClass:[ModuleTableCell class]] && [[oneObject reuseIdentifier] isEqualToString:cellID]){
                cell = (ModuleTableCell *)oneObject;
            };
        };
    };
    
    if([indexPath section]==0){
        switch([indexPath row]){
            case 0:
                cell.moduleName.text = NSLocalizedString(@"iTunes", @"");
                break;
                
            default:
                break;
        };
    }else{
        cell.moduleName.text = @"";
    };
    
    return cell;
    
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0){
        [[[modulePagesArray objectAtIndex:[lastSelectedIndexPath row]] view] removeFromSuperview];
        [[[modulePagesArray objectAtIndex:[indexPath row]] view] setFrame:self.hostView.bounds];
        [self.hostView addSubview:[[modulePagesArray objectAtIndex:[indexPath row]] view]];
        
        if(lastSelectedIndexPath) [lastSelectedIndexPath release];
        lastSelectedIndexPath = [indexPath retain];
        [tableView selectRowAtIndexPath:lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        if([indexPath row]==0){
            [tutorialButton setHidden:NO];
        }else{
            [tutorialButton setHidden:YES];
        };
        
        [self hideSlidingMenu:nil];
    };
};




#pragma mark - Module protoclol implementation

// Initialization of your module. Select NIB-file depending on device (iphone/ipad), set delegate member and perform custom initialization
- (id)initModuleWithDelegate:(id<ServerProtocol>)serverDelegate{
    NSString *nibName;
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
        nibName = @"ImportWeight";
    }else{
        return nil;
    };
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        delegate = serverDelegate;
        if(serverDelegate==nil){
            NSLog(@"WARNING: module \"%@\" initialized without server delegate!", [self getModuleName]);
        };
    }
    return self;
};

// Returns visible module's name
- (NSString *)getModuleName{
    return NSLocalizedString(@"Weight Import", @"");
};

// Returns module's description
- (NSString *)getModuleDescription{
    return NSLocalizedString(@"Import weight data from external sources", @"");
};

// Returns current module's message for a user
- (NSString *)getModuleMessage{
    return @"";
};

// Returns module's version
- (float)getModuleVersion{
    return 1.0;
};

// Returns module's icon image (recommended 50x50 or 100x100 for retina displays)
- (UIImage *)getModuleIcon{
    return [UIImage imageNamed:@"importModule_icon.png"];
};

// Supporting different devices by module (iphone/ipad)
- (BOOL)isInterfaceIdiomSupportedByModule:(UIUserInterfaceIdiom)idiom{
    BOOL res;
    switch (idiom) {
        case UIUserInterfaceIdiomPhone:
            res = YES;
            break;
            
        case UIUserInterfaceIdiomPad:
            res = NO;
            break;
            
        default:
            res = NO;
            break;
    };
    
    return res;
};

// Loading module data.
- (void)loadModuleData{
    
};

// Saving module data. It's recommend to save module's data in single file with module name and .dat extension. File should be place in documents folder.
- (void)saveModuleData{
    
};

// Handler for pressing navigation bar's left button (show of
- (IBAction)pressMainMenuButton{
    [delegate showSlideMenu];
}


// No need to implement at this time
- (id)getModuleValueForKey:(NSString *)key{
    return nil;
};

// No need to implement at this time
- (void)setModuleValue:(id)object forKey:(NSString *)key{
    
};

@end
