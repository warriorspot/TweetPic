
#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import "Request.h"

@interface TweetRequest : Request

@property (nonatomic, strong) TWRequest *request;

- (void) startWithSearchTerm: (NSString *) searchTerm;

@end

extern NSString * const TwitterURL;