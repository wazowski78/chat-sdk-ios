//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "BPublicThreadsViewController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@interface BPublicThreadsViewController ()

@end

@implementation BPublicThreadsViewController

- (id)init
{
    self = [super initWithNibName:Nil bundle:[NSBundle chatUIBundle]];
    if (self) {
 
        self.title = [NSBundle t:bChatRooms];
        self.tabBarItem.image = [UIImage imageNamed: [NSBundle res: @"icn_30_public.png"]];

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _slideToDeleteDisabled = YES;
    
    // Add new group button
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(createThread)];
}

-(void) createThread {
    [self createPublicThread];
}

-(void) createPublicThread {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[NSBundle t:bCreatePublicThread] message:[NSBundle t:bThreadName] delegate:self cancelButtonTitle:[NSBundle t:bCancel] otherButtonTitles:[NSBundle t:bOk], nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    return [[alertView textFieldAtIndex:0].text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Don't create a thread unless connected to the internet
    if ([Reachability reachabilityForInternetConnection].isReachable) {
        
        if (buttonIndex) {
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = [NSBundle t:bCreatingThread];
            
            NSString * name = [alertView textFieldAtIndex:0].text;
            [[BNetworkManager sharedManager].a.publicThread createPublicThreadWithName:name].thenOnMain(^id(id<PThread> thread) {
                
                [self pushChatViewControllerWithThread:thread];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return Nil;
            }, ^id(NSError * error) {
                
                [UIView alertWithTitle:[NSBundle t:bUnableToCreateThread] withError:error];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return error;
            });
        }
    }
}

-(void) reloadData {
    [_threads removeAllObjects];
    [_threads addObjectsFromArray:[[BNetworkManager sharedManager].a.core threadsWithType:bThreadTypePublicGroup]];
    [super reloadData];
}



@end
