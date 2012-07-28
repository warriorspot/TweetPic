
#import <Foundation/Foundation.h>

/// A Tweet instance encapsulates the date, text
/// and the string ID of that tweet. A Tweet instance
/// is immutable.  Use the designated initializer to
/// set the values of tweetId and tweet.
///
@interface Tweet : NSObject

@property (nonatomic, readonly, strong) NSDate *date;
@property (nonatomic, readonly, strong) NSString *tweetId;
@property (nonatomic, readonly, strong) NSString *tweet;

/// Designated Intializer
///
- (id) initWithTweetId: (NSString *) tweetId tweet: (NSString *) tweet date: (NSDate *) date;


@end
