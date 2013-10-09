//
//  StoryViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "StoryViewContr.h"
#import "SimpleTrationView.h"
#import "SimpleTrationSmallView.h"
#import <QuartzCore/QuartzCore.h>



@interface StoryViewContr ()

@end

@implementation StoryViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#define StartX 82
#define StartY 134
#define StartSmalX 522
#define Gap 20
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/5;
    if (initAry.count%5)
        page++;
    if (page > 1)
        rightBg.hidden = NO;
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < 18; i++)
    {
        page = i/5;
        if (i%5 == 0)
        {
            SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
            simpleTranView.tag = i + 1;
            [contentScrolV addSubview:simpleTranView];
            [simpleTranView release];
        }
        else
        {
            int rowX = 0;
            int rowY = 0;
            if (i%5 == 1 || i%5 == 3)
                rowX = 0;
            else
                rowX = 1;
            if (i%5 == 1 || i%5 == 2)
                rowY = 0;
            else
                rowY = 1;
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
            [simpleTraSmalView release];
        }
    }
    
}

- (void)rebuildNewMenuView:(int)midPage
{
    for (int i = (midPage-2)*5; i < initAry.count && i < (midPage+2)*5; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/5;
            if (i%5 == 0)
            {
                SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
                [contentScrolV addSubview:simpleTranView];
                simpleTranView.tag = i+1;
                [simpleTranView release];
            }
            else
            {
                int rowX = 0;
                int rowY = 0;
                if (i%5 == 1 || i%5 == 3)
                    rowX = 0;
                else
                    rowX = 1;
                if (i%5 == 1 || i%5 == 2)
                    rowY = 0;
                else
                    rowY = 1;
                SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
                [contentScrolV addSubview:simpleTraSmalView];
                simpleTraSmalView.tag = i + 1;
                [simpleTraSmalView release];
            }

        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    for (int i = currentPage*4; i < initAry.count && i < (currentPage+1)*4; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/5;
            if (i%5 == 0)
            {
                SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
                [contentScrolV addSubview:simpleTranView];
                simpleTranView.tag = i + 1;
                [simpleTranView release];
            }
            else
            {
                int rowX = 0;
                int rowY = 0;
                if (i%5 == 1 || i%5 == 3)
                    rowX = 0;
                else
                    rowX = 1;
                if (i%5 == 1 || i%5 == 2)
                    rowY = 0;
                else
                    rowY = 1;
                SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
                [contentScrolV addSubview:simpleTraSmalView];
                simpleTraSmalView.tag = i + 1;
                [simpleTraSmalView release];
            }
            
        }

    }
}

- (void)removeRemainMenuView:(int)midPage
{
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*4 + 1 || view.tag > (midPage + 2)*4 + 1)
        {
            NSLog(@"%d-->remove:%p",(view.tag-1)/6, view);
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc
{
    [initAry release];
    [super dealloc];
}


- (IBAction)skipPage:(UIButton*)sender
{
    if (sender == leftBt)
    {
        if (contentScrolV.contentOffset.x >= 1024)
        {
            float offset = contentScrolV.contentOffset.x - 1024;
            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x - 1024, 0) animated:YES];
            if(offset < 1000)
                leftBt.hidden = YES;
        }
        rightBg.hidden = NO;
    }
    else
    {
        if (contentScrolV.contentOffset.x <= contentScrolV.contentSize.width - 1024)
        {
            float offset = contentScrolV.contentOffset.x + 1024;
            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x + 1024, 0) animated:YES];
            if(offset > contentScrolV.contentSize.width - 1040)
                rightBg.hidden = YES;
        }
        leftBt.hidden = NO;
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (scrollView.contentSize.width == 1024)
        {
            leftBt.hidden  = YES;
            rightBg.hidden = YES;
            return;
        }
        if (scrollView.contentOffset.x < 1024 - 100)
            leftBt.hidden = YES;
        else
            leftBt.hidden = NO;
        
        if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
            rightBg.hidden = YES;
        else
            rightBg.hidden = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
    if (scrollView.contentSize.width == 1024)
    {
        leftBt.hidden  = YES;
        rightBg.hidden = YES;
        return;
    }
    if (scrollView.contentOffset.x < 1024 - 100)
        leftBt.hidden = YES;
    else
        leftBt.hidden = NO;
    
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
        rightBg.hidden = YES;
    else
        rightBg.hidden = NO;
}


@end
