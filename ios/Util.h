//
//  Util.h
//
//  Created by andrew on 1/17/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

@interface Util : NSObject
+(NSString*)getConnectionEventName:(NSUInteger)eventEnum;
+(NSString*)getChatEventName:(NSUInteger)eventEnum;
@end
