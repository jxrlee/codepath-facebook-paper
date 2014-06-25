//
//  PaperViewController.m
//  facebook-paper
//
//  Created by Joseph Lee on 6/24/14.
//  Copyright (c) 2014 mn8. All rights reserved.
//

#import "PaperViewController.h"




@interface PaperViewController ()

@property (assign,nonatomic) CGPoint headlineOffset;
@property (assign,nonatomic) CGPoint newsOffset;
@property (assign, nonatomic) float viewWidth;
@property (assign, nonatomic) float viewHeight;
@property (assign, nonatomic) float startY;


@property (weak, nonatomic) IBOutlet UIImageView *headlineImage;
@property (weak, nonatomic) IBOutlet UIScrollView *newsView;

- (IBAction)onHeadlineDrag:(UIPanGestureRecognizer *)sender;


@end




@implementation PaperViewController



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
    
    // get view values
    self.viewWidth = self.view.frame.size.width;
    self.viewHeight = self.view.frame.size.height;

    // hide statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // create scroll view
    CGRect newsFrame = CGRectMake(0, self.viewHeight - 253, self.viewWidth, 253);
    UIScrollView *newsView = [[UIScrollView alloc] initWithFrame:(newsFrame)];
    newsView.bounces = NO;
    [newsView setShowsHorizontalScrollIndicator:NO];
    
    // create news image view
    UIImageView *newsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news.png"]];
    [newsImage setUserInteractionEnabled:YES];
    
    // add subviews
    self.newsView = newsView;
    [newsView addSubview:newsImage];
    [self.view addSubview:self.newsView];
    
    newsView.contentSize = newsImage.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onHeadlineDrag:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan) {

        //NSLog(@"Touch: %f", touchPosition.y);
        
        // set offset
        self.headlineOffset = CGPointMake(touchPosition.x - self.headlineImage.center.x, touchPosition.y - self.headlineImage.center.y);
        self.newsOffset = CGPointMake(0, self.newsView.center.y - self.headlineImage.center.y);
        self.startY = touchPosition.y;
        
        //NSLog(@"Offset %f", self.headlineOffset.y);
        NSLog(@"Center %f", self.headlineImage.center.y);
        NSLog(@"startY %f", self.startY);
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        // get image centers
        float headlineCenter = self.headlineImage.frame.size.width/2;
        float newsCenter = self.newsView.frame.size.width/2;
        
        // set new positions
        if(self.headlineImage.frame.origin.y < 0) {
            
            //NSLog(@"%f %f %f", touchPosition.y, touchPosition.y/10, self.headlineOffset.y);
            NSLog(@"dragging up %f", self.startY + touchPosition.y/10 - self.headlineOffset.y);
            self.headlineImage.center = CGPointMake(headlineCenter, self.startY + touchPosition.y/10 - self.headlineOffset.y);
            self.newsView.center = CGPointMake(newsCenter, self.startY + touchPosition.y/10 - self.headlineOffset.y + self.newsOffset.y);
            
        } else {
            
            NSLog(@"dragging down %f", touchPosition.y - self.headlineOffset.y);
            self.headlineImage.center = CGPointMake(headlineCenter, touchPosition.y - self.headlineOffset.y);
            self.newsView.center = CGPointMake(newsCenter, touchPosition.y - self.headlineOffset.y + self.newsOffset.y);
        
        }

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (self.headlineImage.frame.origin.y > self.viewHeight/2.5) {
            
            NSLog(@"animate down");
            // animate to bottom
            [UIView animateWithDuration:.3 animations:^{
                self.headlineImage.center = CGPointMake(self.viewWidth/2, self.viewHeight*2 - 330);
                self.newsView.center = CGPointMake(self.viewWidth/2, self.viewHeight*2 - 330 + self.newsOffset.y);
            }];
            
        } else {
            
            NSLog(@"animate back");
            // animate to normal
            [UIView animateWithDuration:.3 animations:^{
                self.headlineImage.center = CGPointMake(self.headlineImage.frame.size.width/2, self.headlineImage.frame.size.height/2);
                self.newsView.center = CGPointMake(self.newsView.frame.size.width/2, self.view.frame.size.height - self.newsView.frame.size.height/2);
            }];
            
        }
        
    }
    
}

@end
