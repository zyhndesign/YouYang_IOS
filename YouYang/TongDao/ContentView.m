//
//  ContentView.m
//  YouYang
//
//  Created by sunyong on 13-10-11.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ContentView.h"
#import "AppDelegate.h"
#import "MoviePlayViewContr.h"
#import "AllVariable.h"
#import "ViewController.h"
@implementation ContentView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 1024, 768);
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)_infoDict
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        initDict = [[NSDictionary alloc] initWithDictionary:_infoDict];
        [self addMyView];
    }
    return self;
}

- (void)addMyView
{
    bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
    bgLabel.backgroundColor = [UIColor blackColor];
    bgLabel.alpha = 0.7;
    [self addSubview:bgLabel];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 1024, 718)];
    _webView.detectsPhoneNumbers = NO;
    _webView.delegate = self;
    [self addSubview:_webView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_defult.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_actived.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backButton];
    
    [AllActiveView removeFromSuperview];
    [self addSubview:AllActiveView];
    
    infoDict = [[NSMutableDictionary alloc] init];
    id scroller = [_webView.subviews objectAtIndex:0];
    for(UIView *subView in [scroller subviews])
    {
        if ([[[subView class] description] isEqualToString:@"UIImageView"])
        {
            subView.hidden = YES;
        }
    }
    _webView.scrollView.showsVerticalScrollIndicator   = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = YES;
    
    NSString *doctPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *documentPath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [initDict objectForKey:@"id"]]];
    BOOL dirBOOL = YES;
    if([[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&dirBOOL])
    {
        [AllActiveView stopAnimation];
        [self webViewLoadLocalData];
    }
    else
    {
        [AllActiveView startAnimation];
        [self startLoadSimpleZipData];
    }
}

- (void)dealloc
{
    [_webView removeFromSuperview];
    _webView = nil;
    [bgLabel removeFromSuperview];
    bgLabel = nil;
    
    initDict = nil;
    infoDict = nil;
    keyStr   = nil;
    loadZipNet = nil;
}

- (void)startLoadSimpleZipData
{
    if ([[initDict objectForKey:@"url"] length] > 5)
    {
        loadZipNet = [[LoadZipFileNet alloc] init];
        loadZipNet.delegate = self;
        loadZipNet.urlStr   = [[initDict objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        loadZipNet.md5Str   = [[initDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        loadZipNet.zipStr = [initDict objectForKey:@"id"];
        [QueueZipHandle addTarget:loadZipNet];
    }
}

- (void)webViewLoadLocalData
{
    NSString *doctPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *filePath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc/main.html", [initDict objectForKey:@"id"]]];
    
    NSString *baseUrl = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc", [initDict objectForKey:@"id"]]];
    BOOL doctm = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:baseUrl isDirectory:&doctm])
    {
        NSURLRequest *requestHttp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
        [_webView loadRequest:requestHttp];
        
        NSString *docXmlPath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc.xml", [initDict objectForKey:@"id"]]];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:docXmlPath]];
        xmlParser.delegate = self;
        [xmlParser parse];
    }
}

#pragma mark - net delegate

- (void)didReceiveErrorCode:(NSError *)error
{
    [AllActiveView stopAnimation];
    if ([error code] == -1009)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据连接失败，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    else // ([[[ErrorDict userInfo] objectForKey:NSLocalizedDescriptionKey] isEqual:@"bad URL"])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
}

- (void)didReceiveZipResult:(BOOL)success
{
    [self webViewLoadLocalData];
    [AllActiveView stopAnimation];
}

#pragma mark - xmlParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"showUrl"])
    {
        StartKey = YES;
    }
    else if([elementName isEqualToString:@"videoUrl"])
    {
        StartValue = YES;
    }
    else ;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (StartKey)
    {
        keyStr = [[NSString alloc] initWithFormat:@"%@",string];
    }
    if (StartValue && string.length > 0)
    {
        NSString *str = [infoDict objectForKey:keyStr];
        if (str.length < 1)
            [infoDict setObject:string forKey:keyStr];
        else
            [infoDict setObject:[str stringByAppendingString:string] forKey:keyStr];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    StartKey = NO;
    StartValue = NO;
}


- (void)back:(UIButton*)sender
{
    [AllActiveView stopAnimation];
    [AllActiveView removeFromSuperview];
    [loadZipNet setDelegate:nil];
    [_webView setDelegate:nil];
    [_webView stopLoading];
    
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [self setCenter:CGPointMake(1042+ 512, self.center.y)];
                     }
                     completion:^(BOOL finish){
                         RootViewContr.otherContentV.hidden = YES;
                         UIView *view = [RootViewContr.otherContentV viewWithTag:1010];
                         if (view)
                         {
                             [view removeFromSuperview];
                         }
                         AllOnlyShowPresentOne = 0;
                         [self removeFromSuperview];
                     }];
}

- (void)moviePlayOver:(NSNotification*)notification
{
    self.hidden = NO;
}

#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [[request URL] description];
    if ([urlStr componentsSeparatedByString:@"show_image"].count > 1 || [urlStr componentsSeparatedByString:@"wp-content"].count > 1)
    {
        [RootViewContr imageScaleShow:urlStr];
        return NO;
    }
    else if ([urlStr componentsSeparatedByString:@"show_media"].count > 1)
    {
        NSString *movieUrlStr = [infoDict objectForKey:urlStr];
        if (movieUrlStr.length < 1)
            return NO;
        ///http://lotusprize.com/travel/wp-content/uploads/211/dddd.mp4
        MoviePlayViewContr *moviePlayVCtr = [[MoviePlayViewContr alloc] initwithURL:movieUrlStr];
        [RootViewContr presentViewController:moviePlayVCtr animated:YES completion:nil];
        return NO;
    }
    else if([urlStr componentsSeparatedByString:@"file:"].count > 1)
    {
        return YES;
    }
    else if([urlStr componentsSeparatedByString:@"http:"].count > 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        return NO;
    }
    else ;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [AllActiveView startAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AllActiveView stopAnimation];
}


@end
