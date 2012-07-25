
#import <Foundation/Foundation.h>

/// A Tweet instance encapsulates the text
/// of a tweet and the string ID of that tweet. A Tweet instance
/// is immutable.  Use the designated initializer to
/// set the values of tweetId and tweet.
///
@interface Tweet : NSObject

@property (nonatomic, readonly, strong) NSString *tweetId;
@property (nonatomic, readonly, strong) NSString *tweet;

/// Designated Intializer
///
- (id) initWithTweetId: (NSString *) tweetId tweet: (NSString *) tweet;

/// Returns the longest word in the 'tweet' property of the Tweet
///
- (NSString *) longestWordInTweet;

@end
