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
    frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 400);
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict mode:(int)mode
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 400)];
    if (self) {
        Mode = mode;
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
    
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 160, 40)];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:19];
    [self addSubview:titleLb];
    
    midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 1)];
    midLineLb.backgroundColor = [UIColor whiteColor];
    [self addSubview:midLineLb];

    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 40)];
    timeLb.textColor = [UIColor whiteColor];
    timeLb.textAlignment = NSTextAlignmentCenter;
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:timeLb];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(20, 87, 170, 115)];
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor = [UIColor whiteColor];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    detailTextV.userInteractionEnabled = NO;
    [self addSubview:detailTextV];
    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 204, 160, 160)];
    [self addSubview:proImageV];
    
    if (Mode == 0)
        [self modeTwo];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f;
    paragraphStyle.firstLineHeadIndent = 13.0f;
    NSString *string = [_infoDict objectForKey:@"description"];
    NSDictionary *ats = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    NSAttributedString *atrriString = [[NSAttributedString alloc] initWithString:string attributes:ats];
    detailTextV.attributedText = atrriString;
    [paragraphStyle release];
    [atrriString    release];
    
    NSString *timeStr = [_infoDict objectForKey:@"postDate"];
    if (timeStr.length >= 8)
    {
        NSString *yearStr = [timeStr substringToIndex:4];
        NSString *monthSt = [[timeStr substringFromIndex:4] substringToIndex:2];
        NSString *dayStr  = [timeStr substringFromIndex:6];
        timeLb.text = [NSString stringWithFormat:@"%@/%@/%@", yearStr, monthSt, dayStr];
    }
    titleLb.text       = [_infoDict objectForKey:@"name"];
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
