
#import "FetchMovieOperation.h"
#import "Movie.h"
#import "MovieRequest.h"
#import "Tweet.h"

@interface FetchMovieOperation()

@property BOOL done;
@property (nonatomic, readwrite, strong) UIImage *movieImage;
@property (nonatomic, strong) NSString *currentSearchTerm;
@property (nonatomic, strong) MovieRequest *movieRequest;
@property (nonatomic, readwrite, strong) Tweet *tweet;
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
    
    if(self.movieImage == nil)
    {
        [self downloadMovieImageForRequestResults:nil];
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
