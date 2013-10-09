//
//  SimpleHumanityView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleHumanityView.h"
#import "AllVariable.h"
#import "ContentViewContr.h"
#import "ProImageLoadNet.h"
#import "ViewController.h"

@implementation SimpleHumanityView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 220, 400);
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict mode:(int)mode
{
    self = [super initWithFrame:CGRectMake(0, 0, 220, 400)];
    if (self) {
        Mode = mode;
        _infoDict = [infoDict retain];
        
        [self addView];
    }
    return self;
}

- (void)addView
{
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 180, 40)];
    titleLb.textColor = RedColor;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleLb];
    
    midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 180, 1)];
    midLineLb.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:midLineLb];

    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 180, 40)];
    timeLb.textColor = [UIColor blackColor];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:timeLb];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(16, 87, 188, 92)];
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor = [UIColor blackColor];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    [self addSubview:detailTextV];
    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 204, 180, 180)];
    [self addSubview:proImageV];
    
    if (Mode == 0)
        [self modeTwo];
    
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    titleLb.text       = [_infoDict objectForKey:@"name"];
    detailTextV.text   = [_infoDict objectForKey:@"description"];
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
        [proImageV setImage:[UIImage imageNamed:@"defultbg-180.png"]];
        ProImageLoadNet *proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        [proImageLoadNet loadImageFromUrl:imageURL];
        [proImageLoadNet release];
    }

}


- (void)modeTwo
{
    [proImageV setFrame:CGRectMake(proImageV.frame.origin.x, titleLb.frame.origin.y + 10, proImageV.frame.size.width, proImageV.frame.size.height)];
    
    [titleLb setFrame:CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y + proImageV.frame.size.height + 20, titleLb.frame.size.width, titleLb.frame.size.height)];
    [midLineLb setFrame:CGRectMake(midLineLb.frame.origin.x, midLineLb.frame.origin.y + proImageV.frame.size.height + 20, midLineLb.frame.size.width, midLineLb.frame.size.height)];
    [timeLb setFrame:CGRectMake(timeLb.frame.origin.x, timeLb.frame.origin.y + proImageV.frame.size.height + 20, timeLb.frame.size.width, timeLb.frame.size.height)];
    [detailTextV setFrame:CGRectMake(detailTextV.frame.origin.x, timeLb.frame.origin.y + timeLb.frame.size.height , detailTextV.frame.size.width, detailTextV.frame.size.height)];
    
}

- (void)dealloc
{
    [proImageV   release];
    [timeLb      release];
    [midLineLb   release];
    [timeLb      release];
    [detailTextV release];
    [_infoDict release];
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
