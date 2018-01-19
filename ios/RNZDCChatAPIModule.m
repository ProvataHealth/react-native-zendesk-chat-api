//
//  RNZDCChatAPIModule.m
//
//  Created by andrew on 1/17/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNZDCChatAPIModule.h"
#import <ZDCChatAPI/ZDCChatAPI.h>
#import "Util.h"

@implementation RNZDCChatAPIModule
{
  bool hasListeners;
  NSString *accountKey;
  NSString *lastChatEventId; // chat events come in multiple times from Zendesk, so we don't inform JS if its the same id
}

RCT_EXPORT_MODULE(RNZDCChatAPIModule);

+(BOOL)requiresMainQueueSetup {
  return YES;
}

- (NSDictionary *)constantsToExport
{
  return @{
           @"connectionUpdate": @"connectionUpdate",
           @"chatUpdate": @"chatUpdate",
           @"agentUpdate": @"agentUpdate",
           @"connectionStatusUninitialized" : @"connectionStatusUninitialized",
           @"connectionStatusConnecting" : @"connectionStatusConnecting",
           @"connectionStatusConnected" : @"connectionStatusConnected",
           @"connectionStatusClosed" : @"connectionStatusClosed",
           @"connectionStatusDisconnect" : @"connectionStatusDisconnect",
           @"connectionStatusNoConnection" :  @"connectionStatusNoConnection",
           @"chatAgentJoin" : @"chatAgentJoin",
           @"chatAgentLeave": @"chatAgentLeave",
           @"chatMessage": @"chatMessage",
           @"chatUpload": @"chatUpload",
           @"agentTyping": @"agentTyping"
           };
};

- (NSArray<NSString *> *)supportedEvents
{
  return @[
           @"connectionUpdate",
           @"chatUpdate",
           @"agentUpdate"
           ];
}

RCT_EXPORT_METHOD(init:(NSDictionary *)options) {
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"Initializing chat with accountKey: %@", options[@"accountKey"]);
    accountKey = options[@"accountKey"];
    NSDictionary *userInfo = options[@"userInfo"];
    if ([userInfo count] != 0) {
      NSLog(@"Setting visitor info");
      ZDCVisitorInfo *visitorInfo = [[ZDCChatAPI instance] visitorInfo];
      if (userInfo[@"name"]) {
        [visitorInfo setName:userInfo[@"name"]];
      }
      if (userInfo[@"email"]) {
        [visitorInfo setEmail:userInfo[@"email"]];
      }
      if (userInfo[@"phone"]) {
        [visitorInfo setPhone:userInfo[@"phone"]];
      }
      [[ZDCChatAPI instance] setVisitorInfo:visitorInfo];
    }
  });
}

RCT_EXPORT_METHOD(startChat) {
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"Starting chat");
    [[ZDCChatAPI instance] startChatWithAccountKey:accountKey];
  });
}

RCT_EXPORT_METHOD(endChat) {
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"Ending chat");
    [[ZDCChatAPI instance] endChat];
  });
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)message) {
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"Sending chat message: %@", message);
    [[ZDCChatAPI instance] sendChatMessage:message];
  });
}

- (void)connectionUpdate:(NSNotification *)notification
{
  if (!hasListeners) {
    return;
  }
  ZDCConnectionStatus status = [[ZDCChatAPI instance] connectionStatus];
  NSString *eventName = [Util getConnectionEventName:status];
  NSLog(@"Connection State Updated: %@", eventName);
  [self sendEventWithName:@"connectionUpdate" body:eventName];
}

- (void)chatUpdate:(NSNotification *)notification
{
  if (!hasListeners) {
    return;
  }
  NSArray *events = [[ZDCChatAPI instance] livechatLog];
  ZDCChatEvent *event = [events lastObject];
  if (event.eventId == lastChatEventId) {
    NSLog(@"Duplicate chat event id, skipping");
    return;
  }
  lastChatEventId = event.eventId;
  NSString *eventType = [Util getChatEventName:event.type];
  NSLog(@"Chat Update: %@", eventType);
  if (event) {
    NSDictionary *payload = @{
                          @"eventId": event.eventId,
                          @"timestamp": event.timestamp,
                          @"nickname": event.nickname,
                          @"displayName": event.displayName,
                          @"message": event.message ? event.message : [NSNull null],
                          @"type": eventType,
                          @"firstMessage": @(event.firstMessage),
                          @"leadMessage": @(event.leadMessage),
                          @"fileUpload": event.fileUpload ? event.fileUpload : [NSNull null],
                          @"attachment": event.attachment ? event.attachment : [NSNull null]
                          };
    [self sendEventWithName:@"chatUpdate" body:payload];
  }
}

- (void)agentUpdate:(NSNotification *)notification
{
  if (!hasListeners) {
    return;
  }
  NSArray *agents = [[[ZDCChatAPI instance] agents] allValues];
  if ([agents count] != 0) {
    ZDCChatAgent *agent = [agents objectAtIndex:0];
    NSDictionary *payload = @{
                              @"agentId": agent.agentId,
                              @"displayName": agent.displayName,
                              @"title": agent.title,
                              @"avatarURL": agent.avatarURL,
                              @"typing": @(agent.typing)
                              };
    NSLog(@"Agent update %@", agent.displayName);
    [self sendEventWithName:@"agentUpdate" body:payload];
  }
}

-(void)startObserving {
    hasListeners = YES;
    NSLog(@"Observing connection events");
    [[ZDCChatAPI instance] addObserver:self forConnectionEvents:@selector(connectionUpdate:)];
    [[ZDCChatAPI instance] addObserver:self forChatLogEvents:@selector(chatUpdate:)];
    [[ZDCChatAPI instance] addObserver:self forAgentEvents:@selector(agentUpdate:)];
}

-(void)stopObserving {
    hasListeners = NO;
    [[ZDCChatAPI instance] removeObserverForConnectionEvents:self];
    [[ZDCChatAPI instance] removeObserverForChatLogEvents:self];
    [[ZDCChatAPI instance] removeObserverForAgentEvents:self];
}

@end
