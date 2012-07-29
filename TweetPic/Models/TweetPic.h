
#import <Foundation/Foundation.h>

/// A TweetPic object pairs a tweet with an image.
///
@interface TweetPic : NSObject

/// The date of the tweet the tweet string came from
@property (nonatomic, strong) NSDate *date;

/// Returns a formatted string of the value of the date property
@property (readonly) NSString *dateString;

/// The tweet
@property (nonatomic, strong) NSString *tweet;

/// The image
@property (nonatomic, strong) UIImage *image;

/// Designated initializer
///
- (id) initWithTweet: (NSString *) tweet image: (UIImage *) image date: (NSDate *) date;


@end
