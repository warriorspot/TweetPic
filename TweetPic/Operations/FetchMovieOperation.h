
#import <UIKit/UIKit.h>

@class Movie;
@class Tweet;

/// FetchMovieOperation encapsulates the task of searching for
/// a movie using the RottenTomatoes API that matches any of the
/// words in the supplied Tweet text.  If a movie is found, the
/// thumbnail image of that movie is fetch and stored in the movieImage
/// property.  If no movie is found, a default image is returned.
///
/// FetchMovieOperations are concurrent operations that are run on a
/// background thread when started via an NSOperationQueue.
///
@interface FetchMovieOperation : NSOperation

/// The thumbnail image of a movie found via the RottenTomatoes (RT) API
@property (nonatomic, readonly, strong) UIImage *movieImage;

/// The Tweet whose 'tweet' property is used to find a matching movies.
/// Every word in the tweet is used a search term for the RT API until a
/// movie is found.
@property (nonatomic, readonly, strong) Tweet *tweet;

/// Intialized the request with the give Tweet instance.
///
/// @param tweet
///     the Tweet to use for searching the RT API
///
- (id) initWithTweet: (Tweet *) tweet;

@end
