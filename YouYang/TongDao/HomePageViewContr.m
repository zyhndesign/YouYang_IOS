//
//  HomePageViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "HomePageViewContr.h"
#import "SimpleHeadLineView.h"
#import "ProImageLoadNet.h"
#import "ContentViewContr.h"
#import "ViewController.h"
#import "AllVariable.h"
#import "MovieBgPlayViewCtr.h"

@interface HomePageViewContr ()

@end

@implementation HomePageViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [contentScrolV setContentSize:CGSizeMake(1024*3, 768)];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGestureR];
    [tapGestureR release];
    
    [super viewDidLoad];
}

#define StartX 107
#define StartY 200
#define Gap 15
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    if (initAry.count == 0) 
        return;
    /// 第一个
    if (initAry.count < 1)
        return;
    NSDictionary *infoDict = [initAry objectAtIndex:0];
    titleLb.text = [infoDict objectForKey:@"name"];
    
    NSString *timeStr = [infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    
    NSString *backGround = [infoDict objectForKey:@"background"];
    NSArray *tempAry = [backGround componentsSeparatedByString:@"."];
    if (tempAry.count < 2)
        return;
    if ([[tempAry lastObject] isEqualToString:@"mp4"])
    {
        NSString *pathProFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", [infoDict objectForKey:@"id"], backGround]];
        if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
        {
            movieBgPlayVC = [[MovieBgPlayViewCtr alloc] initwithURL:pathProFile];
            [movieView addSubview:movieBgPlayVC.view];
        }
        else
        {
            [mainImageV setImage:[UIImage imageNamed:@"bg0.png"]];
        }
    }
    else
    {
        NSString *pathProFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", [infoDict objectForKey:@"id"], backGround]];
        if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
        {
            [mainImageV setImage:[UIImage imageWithContentsOfFile:pathProFile]];
        }
        else
        {
            
        }
    }
    
    
    //// 后三个
    for (int i = 1; i < initAry.count; i++)
    {
        if (i > 3)
            break;
        SimpleHeadLineView *simpleHLView = [[SimpleHeadLineView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        [simpleHLView setFrame:CGRectMake(StartX + Gap*(i-1) + simpleHLView.frame.size.width*(i-1), StartY, simpleHLView.frame.size.height, simpleHLView.frame.size.width)];
        [contentScrolV addSubview:simpleHLView];
        [simpleHLView release];
    }
}

- (void)dealloc
{
    [initAry release];
    [super dealloc];
}

#pragma mark - tapGesture
- (void)tapView:(UIGestureRecognizer*)gestureR
{
    CGPoint gestPoint = [gestureR locationInView:self.view];
    if (initAry.count == 0)
        return;
    if (CGRectContainsPoint(CGRectMake(0, 0, 1024, 668), gestPoint))
    {
        ContentViewContr *contentV = [[ContentViewContr alloc] initWithInfoDict:[initAry objectAtIndex:0]];
        [RootViewContr presentViewContr:contentV];
    }
}

#pragma mark - net delegate
- (void)didReciveImage:(UIImage *)backImage
{
    [mainImageV setImage:backImage];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    
}


@end
