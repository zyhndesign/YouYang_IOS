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

#define HeighTopOne 800
#define HeighTopTwo 1350
- (void)rootscrollViewDidScrollToPointY:(int)pointY
{
    if (pointY > 400)
    {
        int positionYOne = 1050 - (pointY - 400)*2/3;
        positionYOne = positionYOne < HeighTopOne ? HeighTopOne:positionYOne;
        int positionYTwo = 1600 - (pointY - 400)*2/3;
        positionYTwo = positionYTwo < HeighTopTwo ? HeighTopTwo:positionYTwo;
        [animaImageViewOne setFrame:CGRectMake(animaImageViewOne.frame.origin.x, positionYOne, animaImageViewOne.frame.size.width, animaImageViewOne.frame.size.height)];
        [animaImageViewTwo setFrame:CGRectMake(animaImageViewTwo.frame.origin.x, positionYTwo, animaImageViewTwo.frame.size.width, animaImageViewTwo.frame.size.height)];
    }
}

- (IBAction)nextPage:(UIButton*)sender
{
    [AllScrollView setContentOffset:CGPointMake(0, (sender.tag*2-1)*768) animated:YES];
}

#define StartX 122
#define StartY 264
#define Gap 30
#define PageSize 3
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/PageSize;
    if (initAry.count%PageSize)
        page++;
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        page = i/PageSize;
        int row = i%PageSize;
        SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
        simpleTraSmalView.tag = i + 1;
        [contentScrolV addSubview:simpleTraSmalView];
        [simpleTraSmalView release];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for (int i = (midPage-2)*PageSize; i < initAry.count && i < (midPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
            [simpleTraSmalView release];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for (int i = (currentPage-2)*PageSize; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
            [simpleTraSmalView release];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*4 + 1 || view.tag > (midPage + 3)*4 + 1)
        {
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc
{
    [initAry release];
    [super dealloc];
}



#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

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
}


@end
