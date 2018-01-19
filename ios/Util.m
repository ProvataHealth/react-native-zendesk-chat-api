//
//  Util.m
//
//  Created by andrew on 1/17/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import <ZDCChatAPI/ZDCChatAPIEnums.h>
#import <ZDCChatAPI/ZDCChatEvent.h>

@implementation Util

+(NSString*)getConnectionEventName:(NSUInteger)eventEnum
{
  NSString *eventName = @"unknown";
  switch (eventEnum)
  {
    case ZDCConnectionStatusUninitialized:
      eventName = @"connectionStatusUninitialized";
      break;
    case ZDCConnectionStatusConnecting:
      eventName = @"connectionStatusConnecting";
      break;
    case ZDCConnectionStatusConnected:
      eventName = @"connectionStatusConnected";
      break;
    case ZDCConnectionStatusClosed:
      eventName = @"connectionStatusClosed";
      break;
    case ZDCConnectionStatusDisconnected:
      eventName = @"connectionStatusDisconnected";
      break;
    case ZDCConnectionStatusNoConnection:
      eventName = @"connectionStatusNoConnection";
      break;
  }
  return eventName;
}

+(NSString*)getChatEventName:(NSUInteger)eventEnum
{
  NSString *eventName = @"unknown";
  switch (eventEnum)
  {
    case ZDCChatEventTypeMemberJoin:
      eventName = @"agentJoin";
      break;
    case ZDCChatEventTypeMemberLeave:
      eventName = @"agentLeave";
      break;
    case ZDCChatEventTypeSystemMessage:
      eventName = @"systemMessage";
      break;
    case ZDCChatEventTypeTriggerMessage:
      eventName = @"triggerMessage";
      break;
    case ZDCChatEventTypeAgentMessage:
      eventName = @"agentMessage";
      break;
    case ZDCChatEventTypeVisitorMessage:
      eventName = @"visitorMessage";
      break;
    case ZDCChatEventTypeVisitorUpload:
      eventName = @"visitorUpload";
      break;
    case ZDCChatEventTypeAgentUpload:
      eventName = @"agentUpload";
      break;
    case ZDCChatEventTypeRating:
      eventName = @"rating";
      break;
    case ZDCChatEventTypeRatingComment:
      eventName = @"ratingComment";
      break;
  }
  return eventName;
}

// Util doesnshouldn't be instantiated
+(id)alloc
{
  [NSException raise:@"Cannot be instantiated!" format:@"Static class 'ClassName' cannot be instantiated!"];
  return nil;
}
@end
