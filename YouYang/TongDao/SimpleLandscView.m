//
//  SimpleLandscView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleLandscView.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ContentViewContr.h"
#import "ViewController.h"

@implementation SimpleLandscView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 240, 240);
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 240, 240)];
    if (self) {
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
    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:proImageV];

    
    titleLb  = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.frame.size.width - 40, 35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor       = [UIColor whiteColor];
    titleLb.textAlignment   = NSTextAlignmentCenter;
    titleLb.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:titleLb];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(22, 90, self.frame.size.width - 35, 105)];
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor = [UIColor grayColor];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    [self addSubview:detailTextV];
    
    titleLb.text = [_infoDict objectForKey:@"name"];
    detailTextV.text = [_infoDict objectForKey:@"description"];
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
        [proImageV setImage:[UIImage imageNamed:@"defultbg-238.png"]];
        ProImageLoadNet *proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        [proImageLoadNet loadImageFromUrl:imageURL];
        [proImageLoadNet release];
    }
}

- (void)dealloc
{
    [proImageV release];
    [titleLb   release];
    [_infoDict release];
    [detailTextV release];
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
