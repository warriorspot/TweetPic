
#import "FetchMovieOperation.h"
#import "Movie.h"
#import "MovieRequest.h"
#import "Tweet.h"

/// Private interface.
///
@interface FetchMovieOperation()

/// If YES, the operation is complete.
@property BOOL done;

/// The movie image fetched from RottenTomatoes, or a default image if no
/// image could be retrived.
@property (nonatomic, readwrite, strong) UIImage *movieImage;

/// The current word from the tweet being used to search for a movie image
@property (nonatomic, strong) NSString *currentSearchTerm;

/// The request used to search the RottenTomatoes API
@property (nonatomic, strong) MovieRequest *movieRequest;

/// The Tweet for which we are trying to find an image
@property (nonatomic, readwrite, strong) Tweet *tweet;

/// The tweet split by the space character, one word per index
@property (nonatomic, strong) NSArray *searchTerms;

@end

@implementation FetchMovieOperation

@synthesize currentSearchTerm;
@synthesize done;
@synthesize movieImage;
@synthesize movieRequest;
@synthesize tweet;
@synthesize searchTerms;

- (id) initWithTweet:(Tweet *)newTweet
{
    self = [super init];
    if(self)
    {
        tweet = newTweet;
    }
    
    return self;
}

#pragma mark - instance methods

- (void) main
{
    NSLog(@"Starting operation for tweet %@", self.tweet.tweetId);
    
    done = NO;
    
    searchTerms = [self.tweet.tweet componentsSeparatedByString:@" "];
    NSUInteger index = 0;
    
    while(!done && index < [searchTerms count])
    {
        if(self.isCancelled) break;
        
        currentSearchTerm = [searchTerms objectAtIndex:index];
        [self requestMoviesForSearchTerm:currentSearchTerm];
        CFRunLoopRun();
        index++;
    }
    
    // We couldn't find a movie poster
    if(self.movieImage == nil)
    {
        self.movieImage = [UIImage imageNamed:@"beer.jpg"];
    }
}

- (void) requestMoviesForSearchTerm: (NSString *) searchTerm
{
    self.movieRequest = [[MovieRequest alloc] init];
    self.movieRequest.delegate = self;
    [self.movieRequest startWithSearchTerm: searchTerm];
}

- (void) downloadMovieImageForRequestResults: (NSArray *) movies
{    
    if(movies == nil)
    {
        self.movieImage = [UIImage imageNamed:@"beer.jpg"];
    }
    else
    {
        Movie *movie = [movies objectAtIndex:0];
        self.movieImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:movie.imageURL]];
    }
    
    done = YES;
}

#pragma mark - RequestDelegate methods

- (void) request:(Request *)request didFailWithError:(NSError *)error
{
    NSLog(@"Request failed: %@", [error localizedDescription]);
    
    [self downloadMovieImageForRequestResults: nil];
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) request:(Request *)request didSucceedWithObject:(id)object;
{
    NSArray *movies = object;
       
    if([movies count] > 0)
    {
        [self downloadMovieImageForRequestResults: movies];
    }
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
