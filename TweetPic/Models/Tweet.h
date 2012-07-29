
#import <Foundation/Foundation.h>

/// A Tweet instance encapsulates the date, text
/// and the string ID of a tweet retreived from the Twitter API.
/// A Tweet instance is immutable.  Use the designated initializer to
/// set the values of tweetId, tweet and date.
///
@interface Tweet : NSObject

/// The date the tweet was sent.
@property (nonatomic, readonly, strong) NSDate *date;

/// The Twitter-assigned id of the tweet
@property (nonatomic, readonly, strong) NSString *tweetId;

/// The text of the tweet.
@property (nonatomic, readonly, strong) NSString *tweet;

/// Designated Initializer
///
- (id) initWithTweetId: (NSString *) tweetId tweet: (NSString *) tweet date: (NSDate *) date;


@end
