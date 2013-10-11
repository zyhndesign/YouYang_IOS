//
//  SimpleTrationView.m
//  TongDao
//
//  Created by sunyong on 13-9-26.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpleTrationSmallView.h"
#import "ProImageLoadNet.h"
#import "AllVariable.h"
#import "ContentViewContr.h"
#import "ViewController.h"

@implementation SimpleTrationSmallView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 240, 240);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    proImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:proImageV];
    
    UILabel *bgLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 35, self.frame.size.width, 35)];
    bgLb.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self addSubview:bgLb];
    [bgLb release];
    
    titleLb  = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 35, self.frame.size.width-10,35)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor       = [UIColor whiteColor];
    titleLb.font = [UIFont boldSystemFontOfSize:17];
    titleLb.text = [_infoDict objectForKey:@"name"];
    [self addSubview:titleLb];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tapGestureR];
    [tapGestureR release];
    
    
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
        [proImageV setImage:[UIImage imageNamed:@"defultbg-200.png"]];
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
