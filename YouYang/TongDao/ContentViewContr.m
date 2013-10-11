//
//  ContentViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ContentViewContr.h"
#import "AppDelegate.h"
#import "MoviePlayViewContr.h"
#import "AllVariable.h"
#import "ViewController.h"
#import "ImageViewShowContr.h"

@interface ContentViewContr ()

@end

@implementation ContentViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithInfoDict:(NSDictionary*)_infoDict
{
    self = [super init];
    if (self)
    {
        initDict = _infoDict;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AllActiveView removeFromSuperview];
    [self.view addSubview:AllActiveView];
    infoDict = [[NSMutableDictionary alloc] init];
    
    
    _webView.opaque = NO;
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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [_webView removeFromSuperview];
    _webView = nil;
    [self.view removeFromSuperview];
    if (keyStr)
        [keyStr release];
    [loadZipNet release];
    [infoDict   release];
    [pool release];
    [super dealloc];
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
        [xmlParser release];
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
        [alerView release];
    }
    else // ([[[ErrorDict userInfo] objectForKey:NSLocalizedDescriptionKey] isEqual:@"bad URL"])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        [alerView release];
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
        if (keyStr)
             [keyStr release];
        keyStr = [string retain];
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


- (IBAction)back:(UIButton*)sender
{
    [AllActiveView stopAnimation];
    [AllActiveView removeFromSuperview];
    [loadZipNet setDelegate:nil];
    [_webView setDelegate:nil];
    [_webView stopLoading];
    
//    ////testsunyong
//    [self dismissViewControllerAnimated:YES completion:nil];
//    return;
    
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [self.view setCenter:CGPointMake(1042+ 512, self.view.center.y)];
                     }
                     completion:^(BOOL finish){
                         [self.view removeFromSuperview];
                         RootViewContr.otherContentV.hidden = YES;
                         UIView *view = [RootViewContr.otherContentV viewWithTag:1010];
                         if (view)
                         {
                             [view removeFromSuperview];
                         }
                         AllOnlyShowPresentOne = 0;
                         [self release];
                     }];
}

- (void)moviePlayOver:(NSNotification*)notification
{
    self.view.hidden = NO;
}



#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [[request URL] description];
    if ([urlStr componentsSeparatedByString:@"show_image"].count > 1 || [urlStr componentsSeparatedByString:@"wp-content"].count > 1)
    {
        ImageViewShowContr *imageViewSContr = [[ImageViewShowContr alloc] initwithURL:urlStr];
        imageViewSContr.view.tag = 1010;
        [RootViewContr imageScaleShow:imageViewSContr];
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
        [moviePlayVCtr release];
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
