
#import <Foundation/Foundation.h>

/// Encapsulates the bare minimum of data returned by a request
/// to the RottenTomatoes API for a given movie needed to create
/// a TweetPic instance.
///
@interface Movie : NSObject

/// The title of the movie.
@property (nonatomic, strong) NSString *title;

/// The URL to a thumbnail image of the movie poster.
@property (nonatomic, strong) NSURL *imageURL;

@end
