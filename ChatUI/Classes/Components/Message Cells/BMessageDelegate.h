//
//  BMessageDelegate.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 26/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "PMessageLayout.h"

#import <ChatSDK/PElmMessage.h>

@protocol BMessageDelegate <NSObject>

-(void) setMessage: (id<PElmMessage, PMessageLayout>) message;
-(void) setMessage: (id<PElmMessage, PMessageLayout>) message withColorWeight: (float) colorWeight;

-(void) willDisplayCell;

@end
