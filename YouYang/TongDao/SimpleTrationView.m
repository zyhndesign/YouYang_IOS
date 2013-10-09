//
//  SimpleTrationView.m
//  TongDao
//
//  Created by sunyong on 13-9-27.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleTrationView.h"
#import "AllVariable.h"
#import "ContentViewContr.h"
#import "ProImageLoadNet.h"
#import "ViewController.h"

@implementation SimpleTrationView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 420, 420);
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)infoDict
{
    self = [super initWithFrame:CGRectMake(0, 0, 420, 420)];
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
    
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:proImageV];
    
    bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 212, 260, 188)];
    [bgImageV setImage:[UIImage imageNamed:@"articletitle_wuyu_bg1.png"]];
    [self addSubview:bgImageV];
    
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(45, 221, 210, 40)];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont boldSystemFontOfSize:20];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLb];
    
    midLineLb = [[UILabel alloc] initWithFrame:CGRectMake(45, 269, 210, 1)];
    midLineLb.backgroundColor = [UIColor whiteColor];
    [self addSubview:midLineLb];
    
    detailTextV = [[UITextView alloc] initWithFrame:CGRectMake(40, 279, 225, 105)];
    detailTextV.font = [UIFont systemFontOfSize:14];
    detailTextV.textColor = [UIColor whiteColor];
    detailTextV.backgroundColor = [UIColor clearColor];
    detailTextV.editable = NO;
    detailTextV.scrollEnabled = NO;
    [self addSubview:detailTextV];
    
    titleLb.text       = [_infoDict objectForKey:@"name"];
    detailTextV.text   = [[_infoDict objectForKey:@"description"] stringByAppendingString:[_infoDict objectForKey:@"description"]];
    NSString *imageURL = [_infoDict objectForKey:@"profile"];
    NSArray *tempAry = [imageURL componentsSeparatedByString:@"."];
    imageURL = [tempAry objectAtIndex:0];
    for (int i = 1; i < tempAry.count; i++)
    {
        if (i == tempAry.count - 1)
        {
            imageURL = [NSString stringWithFormat:@"%@-400x400.%@", imageURL, [tempAry objectAtIndex:i]];
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
        [proImageV setImage:[UIImage imageNamed:@"defultbg-420.png"]];
        ProImageLoadNet *proImageLoadNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
        proImageLoadNet.delegate = self;
        [proImageLoadNet loadImageFromUrl:imageURL];
        [proImageLoadNet release];
    }
}

- (void)dealloc
{
    [proImageV   release];
    [bgImageV    release];
    [titleLb     release];
    [midLineLb   release];
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
