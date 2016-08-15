//
//  APIController.h
//  HeroTracker
//
//  Created by Ben Gohlke on 8/8/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIController : NSObject

+ (APIController *)sharedAPIController;
- (void)searchForCharacter:(NSString *)characterName;

@end
