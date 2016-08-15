//
//  APIController.m
//  HeroTracker
//
//  Created by Ben Gohlke on 8/8/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

#import "APIController.h"
#import <CommonCrypto/CommonDigest.h>

@interface APIController ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation APIController

static NSString *marvelCharacterSearchUrl = @"https://gateway.marvel.com/v1/public/characters?ts=%@&name=%@&apikey=%@&hash=%@";

static NSString *publicAPIKey = @"Your public API Key goes here";
static NSString *privateAPIKey = @"Your private API Key goes here";

+ (APIController *)sharedAPIController
{
    static APIController *sharedAPIController = nil;
    if (sharedAPIController)
        return sharedAPIController;
    
    // Use Grand Central Dispatch to only init one instance of NetworkManager, makes the singleton thread-safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPIController = [[APIController alloc] init];
    });
    
    return sharedAPIController;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    
    return self;
}

- (void)searchForCharacter:(NSString *)characterName
{
    // Creates an NSString object with the number of seconds since 1970
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    // Follows Marvel API Documentation that says to concatenate the timestamp, the private key, and the public key
    NSString *keysWithDateStamp = [NSString stringWithFormat:@"%@%@%@", ts, privateAPIKey, publicAPIKey];
    
    //Performs an MD5 hash on the above string, and returns a string
    NSString *hash = [self md5:keysWithDateStamp];
    
    // Combines the base URL string with the data we just calculated above
    NSString *fullUrlString = [NSString stringWithFormat:marvelCharacterSearchUrl, ts, characterName, publicAPIKey, hash];
    NSLog(@"full URL: %@", fullUrlString);
    
    // Creates an NSURL object from the string above
    NSURL *url = [NSURL URLWithString:fullUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *characterInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (characterInfo)
            {
                NSLog(@"characterInfo: %@", characterInfo);
            }
        }
    }];
    [dataTask resume];
}

// From Stack Overflow: http://stackoverflow.com/a/16889734
- (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

@end