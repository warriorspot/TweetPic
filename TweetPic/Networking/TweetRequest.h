
#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import "Request.h"

/// TweetRequest requests tweets from the Twitter API based on a supplied
/// keyword.  If successful, returns a populated Tweet instance via
/// the request:didSucceedWithObject: delegate method.
///
@interface TweetRequest : Request

/// The specific request used to access the Twitter API
@property (nonatomic, strong) TWRequest *request;

/// Starts a new request for tweet that contain the given search term.
///
/// @param searchTerm
///     the text used to match tweets via the Twitter API
///
- (void) startWithSearchTerm: (NSString *) searchTerm;

@end
