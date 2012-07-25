
#import <Foundation/Foundation.h>

/// A TweetPic object pairs a tweet with an image.
///
@interface TweetPic : NSObject

/// The tweet
@property (nonatomic, strong) NSString *tweet;

/// The image
@property (nonatomic, strong) UIImage *image;

/// Designated initializer
///
- (id) initWithTweet: (NSString *) tweet image: (UIImage *) image;


@end
