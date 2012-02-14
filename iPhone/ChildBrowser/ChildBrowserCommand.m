//

// 
//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright (c) 2011, IBM Corporation
//  Copyright 2011, Randy McMillan
//

#import "MainViewController.h"
#import "ChildBrowserCommand.h"


@implementation ChildBrowserCommand

@synthesize childBrowser;

- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{	
	
    if(childBrowser == NULL)
	{
		childBrowser = [[ ChildBrowserViewController alloc ] initWithScale:NO ];
		childBrowser.delegate = self;
	}
	
/* // TODO: Work in progress
	NSString* strOrientations = [ options objectForKey:@"supportedOrientations"];
	NSArray* supportedOrientations = [strOrientations componentsSeparatedByString:@","];
*/
    MainViewController* cont = (MainViewController*)[ super viewController ];
    childBrowser.supportedOrientations = cont.supportedOrientations;
    [cont presentWithAnimation: childBrowser];
    
/*    childBrowser.modalPresentationStyle = UIModalPresentationFormSheet;
    if ([cont respondsToSelector:@selector(presentViewController)]) {
        //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        [cont presentViewController:childBrowser animated:YES completion:nil];        
    } else {
        [ cont presentModalViewController:childBrowser animated:YES ];
    }                 
*/        
    NSString *url = (NSString*) [arguments objectAtIndex:0];
        
    [childBrowser loadURL:url  ];
        
}

-(void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{
    [ childBrowser closeBrowser];
	
}

-(NSString*) jsExec:(NSString *)jsString {
	return [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void) onClose {
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onClose();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

-(void) onOpenInSafari {
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onOpenExternal();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}


-(void) onChildLocationChange:(NSString*)newLoc {
	
	NSString* tempLoc = [NSString stringWithFormat:@"%@",newLoc];
	NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	 
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onLocationChange('%@');",encUrl];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];

}

-(void) onLoadError:(NSString *)url msg:(NSString *)msg {
	NSString* tempLoc = [NSString stringWithFormat:@"%@",url];
	NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onLoadError('%@','%@');", encUrl, msg];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}



@end
