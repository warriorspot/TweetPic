
#import "Movie.h"
#import "FetchMovieOperation.h"
#import "Tweet.h"
#import "TweetPic.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"
#import "TweetRequest.h"

static NSUInteger const MaximumConcurrentOperations = 10;

/// Private interface
///
@interface TweetPicManager()
{
    /// Background task identifier
    UIBackgroundTaskIdentifier bgTask;
}

/// The operation queue used to queue up and execute FetchMovieOperation
/// operations.
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/// A TweetRequest used to query the Twiter API
@property (nonatomic, strong) TweetRequest *tweetRequest;

/// Handler for the DidEnterSearchTermNotification.  Checks for an already
/// active "session" of building TweetPics, and returns immediately if a
/// "session" is active.  Otherwise, creates a new TweetRequest for the
/// given search term and starts building TweetPics
///
/// @param notification
///     the notification object
///
- (void) didEnterSearchTerm: (NSNotification *) notification;

/// Creates and queues a new FetchMovieRequest for the given Tweet instance.
///
/// the Tweet whos tweet text is used to query RottenTomatoes for a movie
/// poster thumbnail image.
///
/// @param tweet
///     the Tweet instance to fetch a movie image for
///
- (void) fetchMovieForTweet: (Tweet *) tweet;

/// Posts a TweetPicsCreateNotification.  Ends the current background
/// task (if needed).
///
- (void) postNotificationForCompletion;

/// Posts a TweetPicCreatedNotification containing the given
/// TweetPic.
///
/// @param tweetPic
///     the TweetPic to include in the notification
///
- (void) postNotificationForTweetPic: (TweetPic *) tweetPic;

/// Calls waitUntilAllOperationsAreFinished on the NSOperationQueue. This
/// causes the current thread to be blocked until the queue is empty.  Calls
/// postNotificationForCompletion on the main thread as soon as the queue is
/// empty.
///
/// This method must not be called on the main thread!!
///
- (void) wait;

@end


@implementation TweetPicManager

@synthesize tweetRequest;
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
        self.operationQueue.maxConcurrentOperationCount = MaximumConcurrentOperations;
        bgTask = UIBackgroundTaskInvalid;
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

    NSString *errorMessage = nil;
    
    if(error)
    {
        errorMessage = [error localizedDescription];
    }
    else
    {
        errorMessage = NSLocalizedString(@"ERROR_TWITTER_REQUEST_FAILED", nil);
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: errorMessage
                                                         forKey:TweetPicErrorDescriptionKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicErrorNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void) request:(Request *)request didSucceedWithObject:(id)object;
{
    if(bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if(bgTask != UIBackgroundTaskInvalid)
        {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        }
    }];
    
    NSArray *newTweets = (NSArray *) object;
    
    for(Tweet *tweet in newTweets)
    {
        [self fetchMovieForTweet:tweet];
    }
    
    [self performSelectorInBackground:@selector(wait) withObject:nil];
}

#pragma mark - private methods

- (void) didEnterSearchTerm: (NSNotification *) notification
{
    if(self.tweetRequest.active || [self.operationQueue operationCount] > 0)
    {
        NSLog(@"%@", @"Busy");
        return;
    }
    
    self.tweetRequest = [[TweetRequest alloc] init];
    self.tweetRequest.delegate = self;
    [self.tweetRequest startWithSearchTerm:[notification.userInfo valueForKey: SearchTermKey]];
}

- (void) fetchMovieForTweet: (Tweet *) tweet
{
    NSLog(@"Fetching image for tweet: %@", tweet.tweetId);
    
    FetchMovieOperation *operation = [[FetchMovieOperation alloc] initWithTweet:tweet];
    
    [operation addObserver:self
                forKeyPath:@"isFinished"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
    
    [self.operationQueue addOperation:operation];
}

- (void) postNotificationForTweetPic: (TweetPic *) tweetPic
{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tweetPic
                                                         forKey:TweetPicKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicCreatedNotification 
                                                        object:self 
                                                      userInfo:userInfo];
}

- (void) postNotificationForCompletion
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicsCreatedNotification
                                                        object:self
                                                      userInfo:nil];
    if(bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }
}

- (void) wait
{
    @autoreleasepool {
        [self.operationQueue waitUntilAllOperationsAreFinished];
        [self performSelectorOnMainThread:@selector(postNotificationForCompletion)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    FetchMovieOperation *operation = (FetchMovieOperation *) object;
    
    TweetPic *tweetPic = [[TweetPic alloc] initWithTweet:operation.tweet.tweet
                                                   image:operation.movieImage
                                                    date:operation.tweet.date];
    
    [self performSelectorOnMainThread:@selector(postNotificationForTweetPic:)
                           withObject:tweetPic
                        waitUntilDone:NO];
}

@end

NSString * const TweetPicCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicKey = @"TweetPicKey";

NSString * const TweetPicsCreatedNotification = @"TweetPicsCreated";

NSString * const TweetPicErrorNotification = @"TweetPicError";
NSString * const TweetPicErrorDescriptionKey = @"TweetPicErrorKey";

