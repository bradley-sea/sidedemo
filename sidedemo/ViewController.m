//
//  ViewController.m
//  sidedemo
//
//  Created by Brad on 1/26/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIViewController *redVC;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.redVC = [self.storyboard instantiateViewControllerWithIdentifier:@"red"];
    [self addChildViewController:self.redVC];
    self.redVC.view.frame = self.view.frame;
    [self.view addSubview:self.redVC.view];
    [self.redVC didMoveToParentViewController:self];
    
    [self.redVC.view.layer setShadowColor:[UIColor blackColor].CGColor];
	[self.redVC.view.layer setShadowOpacity:0.8];
	[self.redVC.view.layer setShadowOffset:CGSizeMake(2,2)];
    
    [self setupSlideGesture];
    
}

-(void)setupSlideGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
}

-(void)slidePanel:(id)sender
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    //clear out animations
//    [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];
    
    CGPoint velocity = [pan velocityInView:[pan view]];
    CGPoint translatedPoint = [pan translationInView:[pan view]];
    NSLog(@"%f",velocity.x);
    NSLog(@"%f",translatedPoint.x);
    
    if ([pan state] == UIGestureRecognizerStateChanged)
    {
        if (self.redVC.view.frame.origin.x + translatedPoint.x > 0)
        {
            self.redVC.view.center = CGPointMake(self.redVC.view.center.x + translatedPoint.x, self.redVC.view.center.y);
            //super important:
            [pan setTranslation:CGPointMake(0,0) inView:self.view];
        }
    }
    
    if ([pan state] == UIGestureRecognizerStateEnded)
    {
        if (self.redVC.view.frame.origin.x > self.view.frame.size.width /4)
        {
            
            [UIView animateWithDuration:.3 animations:^{
                
                self.redVC.view.frame = CGRectMake(self.view.frame.size.width *.8, self.redVC.view.frame.origin.y, self.redVC.view.frame.size.width,self.redVC.view.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
                [self.redVC.view addGestureRecognizer:tap];
              
            }];
        }
        else
        {
            [UIView animateWithDuration:.3 animations:^{
                
                self.redVC.view.frame = self.view.frame;
                
            }];
        }
    }
}

-(void)slideBack:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.redVC.view.frame = self.view.frame;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
