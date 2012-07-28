
#import "Movie.h"
#import "MovieRequest.h"
#import "FetchMovieOperation.h"
#import "Tweet.h"
#import "TweetPic.h"
#import "TweetPicManager.h"
#import "TweetPicManager+Private.h"
#import "TweetPicViewController.h"
#import "TweetRequest.h"

@implementation TweetPicManager

@synthesize tweetRequest;
@synthesize tweets;
@synthesize movieRequest;
@synthesize operationQueue;

- (id) init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didEnterSearchTerm:) 
                                                     name:DidEnterSearchTermNotification 
                                                   object:nil];
        operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - RequestDelegate methods

- (void) request:(Request *)request didFailWithError:(NSError *)error
{
    NSLog(@"Request failed: %@", [error localizedDescription]);
}

- (void) request:(Request *)request didSucceedWithObject:(id)object;
{
    if([request isKindOfClass:[TweetRequest class]])
    {
        NSArray *newTweets = (NSArray *) object;
        self.tweets = [NSMutableArray arrayWithArray:newTweets];       
        [self fetchMovieForTweet:[self.tweets lastObject]];
    }
    else if([request isKindOfClass:[MovieRequest class]])
    {
        NSArray *movies = object;
                
        [self performSelectorInBackground:@selector(downloadMovieImageForRequestResults:) withObject:movies];
    }
}


#pragma mark - UIAlertView delegate methods

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - private methods

- (void) didEnterSearchTerm: (NSNotification *) notification
{
    if((self.movieRequest && self.movieRequest.active) || self.tweetRequest.active)
    {
        return;
    }
    
    self.tweetRequest = [[TweetRequest alloc] init];
    self.tweetRequest.delegate = self;
    [self.tweetRequest startWithSearchTerm:[notification.userInfo valueForKey: SearchTermKey]];
}

- (void) downloadMovieImageForRequestResults: (NSArray *) movies
{
    @autoreleasepool 
    {
    Tweet *tweet =  [self.tweets lastObject];
    TweetPic *tweetPic = [[TweetPic alloc] init];
    tweetPic.tweet = tweet.tweet;
    
    UIImage *image = nil;
    
    if([movies count] > 0)
    {
        Movie *movie = [movies objectAtIndex:0];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:movie.imageURL]];
    }
    else
    {
        image = [UIImage imageNamed:@"beer.jpg"];
    }
    
    tweetPic.image = image;
    
    [self performSelectorOnMainThread:@selector(postNotificationForTweetPic:) withObject:tweetPic waitUntilDone:NO];
    }
}

- (void) fetchMovieForTweet: (Tweet *) tweet
{
    NSLog(@"Fetching image for tweet: %@", tweet.tweetId);
    
    FetchMovieOperation *operation = [[FetchMovieOperation alloc] initWithTweet:tweet];
    [self.operationQueue addOperation:operation];
    
//    self.movieRequest = [[MovieRequest alloc] init];
//    self.movieRequest.delegate = self;
//    NSString *searchTerm = [tweet longestWordInTweet];
//    [self.movieRequest startWithSearchTerm: searchTerm];
}

- (void) postNotificationForTweetPic: (TweetPic *) tweetPic
{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tweetPic
                                                         forKey:TweetPicKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicCreatedNotification 
                                                        object:self 
                                                      userInfo:userInfo];
    [self.tweets removeLastObject];
    
    if([self.tweets count] > 0)
    {
        [self fetchMovieForTweet:[self.tweets lastObject]];
    }
}

@end

NSString * const TweetPicCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicsCreatedNotification = @"TweetPicsCreated";
NSString * const TweetPicsKey = @"TweetPicsKey";
NSString * const TweetPicKey = @"TweetPicKey";
