//
//  WeightControlQuartzPlotGLES.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 03.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"
#import "WeightControl.h"
#import <mach/mach.h>

@class Texture2D;
@class WeightControl;


@interface WeightControlQuartzPlotGLES : UIView {
    EAGLContext *plotContext;
    
    void *myRender;
    
    int drawingsCounter;
    float timestamp, panTimestamp;
    
    float startScale, curScale;
    float startPanOffset, curPanOffset;
    
    float lastShowedTiPerPx, lastShowedTimeIntervalInCenter;
    
    float contentScale; // 2.0 or 1.0 (retina or no)
    
    unsigned long lastClock;
    NSString *fpsStr;
    
    bool tmpVal;
    
    BOOL pauseRedraw;
    
    NSCalendar *gregorian;
    NSDateFormatter *dateFormatter;
    NSMutableDictionary *allGLESLabels;
    
    GLuint backgroundTextureId;
    float texturesInVertical, texturesInHorizontal;
}

@property (nonatomic, assign) WeightControl *delegateWeight;


- (id)initWithFrame:(CGRect)frame andDelegate:(WeightControl *)_delegate;

- (NSTimeInterval)firstDayOfMonth:(NSTimeInterval)dateMonth;
- (NSTimeInterval)firstDayOfYear:(NSTimeInterval)dateYear;
- (NSDate *)dateFromComponents:(NSDateComponents *)dateComp;
- (NSUInteger)dayOfMonthForDate:(NSDate *)testDate;

- (Texture2D *)getTexture2DForStringLazy:(NSString*)string dimensions:(CGSize)dimensions alignment:(UITextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size;


- (void)updatePlotLowLayerBase;
- (void)showLastDayInCenterWithTiPerPx:(float)tiPerPx;

- (GLuint)createTextureForImage:(NSString *)imageName;

- (void) drawView: (CADisplayLink*) displayLink;
- (UIImage *)getViewScreenshot;
- (void)_testHorizontalLinesAnimating;

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)gestureRecognizer;
//- (void)performSmoothScrollRecrsive:(float)_timeInterval;

- (void)setRedrawOpenGLPaused:(BOOL)_isPaused;
- (BOOL)isOpenGLPaused;
- (void)reallocCache;


- (vm_size_t)usedMemory;
- (vm_size_t)freeMemory;
- (void)logMemUsage;


@end
