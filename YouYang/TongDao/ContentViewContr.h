//
//  ContentViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "LoadZipFileNet.h"
#import "ActiveView.h"

@interface ContentViewContr : UIViewController<UIWebViewDelegate, NSXMLParserDelegate, NetworkDelegate>
{
    ActiveView *activeView;
    IBOutlet UIWebView *_webView;
    NSDictionary *initDict;
    NSMutableDictionary *infoDict;
    
    NSString *keyStr;
    BOOL StartKey;
    BOOL StartValue;
    LoadZipFileNet *loadZipNet;
}
- (id)initWithInfoDict:(NSDictionary*)infoDict;
- (IBAction)back:(UIButton*)sender;
@end
