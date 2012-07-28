
#import <UIKit/UIKit.h>

@class Movie;
@class Tweet;

@interface FetchMovieOperation : NSOperation

@property (nonatomic, readonly, strong) UIImage *movieImage;
@property (nonatomic, readonly, strong) Tweet *tweet;

- (id) initWithTweet: (Tweet *) tweet;

@end
