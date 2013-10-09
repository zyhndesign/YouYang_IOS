//
//  HumanityViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "HumanityViewContr.h"
#import "SimpleHumanityView.h"


@interface HumanityViewContr ()

@end

@implementation HumanityViewContr

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

#define HeighTopOne 450
#define HeighTopTwo 300
#define HeighTopThr 1200
- (void)rootscrollViewDidScrollToPointY:(int)pointY
{
    if (pointY > 400)
    {
        int positionYOne = 600 - (pointY - 400)*2/3;
        positionYOne = positionYOne < HeighTopOne ? HeighTopOne:positionYOne;
        int positionYTwo = 550 - (pointY - 400)*2/3;
        positionYTwo = positionYTwo < HeighTopTwo ? HeighTopTwo:positionYTwo;
        int positionYThr = 1400 - (pointY - 400)*2/3;
        positionYThr = positionYThr < HeighTopThr ? HeighTopThr:positionYThr;
        [animaImageViewOne setFrame:CGRectMake(animaImageViewOne.frame.origin.x, positionYOne, animaImageViewOne.frame.size.width, animaImageViewOne.frame.size.height)];
        [animaImageViewTwo setFrame:CGRectMake(animaImageViewTwo.frame.origin.x, positionYTwo, animaImageViewTwo.frame.size.width, animaImageViewTwo.frame.size.height)];
        [animaImageViewThr setFrame:CGRectMake(animaImageViewThr.frame.origin.x, positionYThr, animaImageViewThr.frame.size.width, animaImageViewThr.frame.size.height)];
    }
}

#define StartX 112
#define StartY 200
#define PageSize 4
- (void)loadSubview:(NSArray*)ary
{
    initAry = [ary retain];
    int page = initAry.count/PageSize;
    if (initAry.count%PageSize)
        page++;
    [contentScrolV setContentSize:CGSizeMake(page*1024, contentScrolV.frame.size.height)];
    
    for (int i = 0; i < initAry.count; i++)
    {
        page = i/PageSize;
        if (i%PageSize && i != (initAry.count-1))
        {
            UILabel *midLb = [[UILabel alloc] initWithFrame:CGRectMake(page*1024 + StartX + (i%PageSize)*200 -1, StartY + 15, 1, 400 - 50)];
            midLb.backgroundColor = [UIColor lightGrayColor];
            [contentScrolV addSubview:midLb];
            [midLb release];
        }
    }
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        page = i/PageSize;
        SimpleHumanityView *simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
        simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
        simpleHimanView.tag = i + 1;
        [contentScrolV addSubview:simpleHimanView];
        [simpleHimanView release];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;

    for (int i = (midPage-2)*PageSize; i < initAry.count && i <= (midPage+2)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%PageSize)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
            [simpleHimanView release];
        }
    }
}

- (void)rebulidCurrentPage:(NSNumber*)currentPageNum
{
    if (initAry.count < PageSize*3)
        return;
    
    int currentPage = [currentPageNum intValue];
    for (int i = (currentPage-2)*PageSize; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
            [simpleHimanView release];
            
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for(UIView *view in [contentScrolV subviews])
    {
        if ((view.tag < (midPage - 2)*4 + 1 || view.tag > (midPage + 3)*4 + 1) && view.tag != 0)
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


- (IBAction)nextPage:(UIButton*)sender
{
    [AllScrollView setContentOffset:CGPointMake(0, (sender.tag*2-1)*768) animated:YES];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"endDecelering");
    NSInteger page = (scrollView.contentOffset.x+100)/1024 + 1;
    [self rebulidCurrentPage:[NSNumber numberWithInt:page]];

}


@end
