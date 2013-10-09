//
//  SimpleHeadLineView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHeadLineView.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ContentViewContr.h"
#import "ViewController.h"

@implementation SimpleHeadLineView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 260, 410);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addView];
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 260, 410)];
    if (self)
    {
        _infoDict = [infoDict retain];
        [self addView];
    }
    return self;
}

- (void)addView
{
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    [tapGestureR release];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView release];
    
    /////defultbg-210.png
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 210, 210)];
    [whiteView addSubview:proImageV];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(14, 240, 201, 35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor       = RedColor;
    titleLb.font = [UIFont boldSystemFontOfSize:17];
    titleLb.text = [_infoDict objectForKey:@"name"];
    [whiteView addSubview:titleLb];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(9, 278, 223, 70)];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.textColor       =  [UIColor darkGrayColor];
    detailTextV.font = [UIFont systemFontOfSize:13];
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    [whiteView addSubview:detailTextV];
    
    ///////////
    UIImageView *redImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_bg.png"]];
    [redImageV setFrame:CGRectMake(0, 15, 90, 53)];
    [self addSubview:redImageV];
    [redImageV release];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, 60, 22)];
    titleLb.textAlignment = NSTextAlignmentRight;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLb];
    
    yearLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 29, 60, 22)];
    yearLb.textAlignment = NSTextAlignmentRight;
    yearLb.backgroundColor = [UIColor clearColor];
    yearLb.textColor = [UIColor whiteColor];
    yearLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:yearLb];
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        yearLb.text = yearStr;
        NSString *monthStr = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr   = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@", monthStr, dayStr];
    }

    NSString *imageURL = [_infoDict objectForKey:@"profile"];
    NSArray *tempAry = [imageURL componentsSeparatedByString:@"."];
    imageURL = [tempAry objectAtIndex:0];
    for (int i = 1; i < tempAry.count; i++)
    {
        if (i == tempAry.count - 1)
        {
            imageURL = [NSString stringWithFormat:@"%@-200x200.%@", imageURL, [tempAry objectAtIndex:i]];
        }
        else
            imageURL = [NSString stringWithFormat:@"%@.%@", imageURL, [tempAry objectAtIndex:i]];
    }
    
    NSString *ProImgeFormat = [[imageURL componentsSeparatedByString:@"."] lastObject];
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_infoDict objectForKey:@"id"], ProImgeFormat]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathProFile])
    {
        [proImageV setImage:[UIImage imageWithContentsOfFile:pathProFile]];
    }
    else
    {
        [proImageV setImage:[UIImage imageNamed:@"defultbg-210.png"]];
        ProImageLoadNet *proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        [proImageLoadNet loadImageFromUrl:imageURL];
        [proImageLoadNet release];
    }
}

- (void)dealloc
{
    [proImageV   release];
    [titleLb     release];
    [detailTextV release];
    [timeLb      release];
    [yearLb      release];
    [_infoDict   release];
    [super dealloc];
}

#pragma mark - tapGesture

- (void)tapView
{
    ContentViewContr *contentV = [[ContentViewContr alloc] initWithInfoDict:_infoDict];
    [RootViewContr presentViewContr:contentV];
}


#pragma mark - net delegate
- (void)didReciveImage:(UIImage *)backImage
{
    [proImageV setImage:backImage];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    
}


@end
