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
    frame = CGRectMake(frame.origin.x, frame.origin.y, 210, 410);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addView];
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 210, 410)];
    if (self)
    {
        _infoDict = [infoDict retain];
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    [tapGestureR release];
    
    /////defultbg-210.png
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
    [self addSubview:proImageV];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 210, 35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor       = [UIColor blackColor];
    titleLb.font = [UIFont boldSystemFontOfSize:18];
    titleLb.text = [_infoDict objectForKey:@"name"];
    [self addSubview:titleLb];
    
    UILabel *midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(14, 278, 180, 1)];
    midLineLb.backgroundColor = [UIColor grayColor];
    [self addSubview:midLineLb];
    [midLineLb release];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(8, 282, 200, 95)];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.textColor       =  [UIColor darkGrayColor];
    detailTextV.font = [UIFont systemFontOfSize:13];
    detailTextV.text = [_infoDict objectForKey:@"description"];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    [self addSubview:detailTextV];
    
    //////////
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
