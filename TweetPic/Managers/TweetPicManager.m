
#import "MovieRequest.h"
#import "Tweet.h"
#import "TweetPic.h"
#import "TweetPicManager.h"
#import "TweetPicManager+Private.h"
#import "TweetPicViewController.h"
#import "TweetRequest.h"

@implementation TweetPicManager

@synthesize movieRequest;
@synthesize tweetRequest;
@synthesize tweetToRequest;

- (id) init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didEnterSearchTerm:) 
                                                     name:DidEnterSearchTermNotification 
                                                   object:nil];
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

- (void) request:(Request *)request didSucceed:(NSDictionary *) json;
{
    NSArray *results = [json valueForKey:@"results"];
    NSMutableArray *tweetPics = [NSMutableArray array];
    
    for(NSDictionary *result in results)
    {
        NSString *tweet = [result valueForKey:@"text"];
        NSString *tweetId = [result valueForKey: @"stringId"];
        NSLog(@"Tweet: %@", tweet);
        
        Tweet *newTweet = [[Tweet alloc] initWithTweetId: tweetId tweet: tweet];
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tweetPics 
                                                          forKey:TweetPicsKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicsCreatedNotification 
                                                        object:self 
                                                      userInfo:userInfo];
}

#pragma mark - private methods

- (void) didEnterSearchTerm: (NSNotification *) notification
{
    if(self.movieRequest.active || self.tweetRequest.active)
    {
        return;
    }
    
    self.tweetRequest = [[TweetRequest alloc] init];
    self.tweetRequest.delegate = self;
    [self.tweetRequest startWithSearchTerm:[notification.userInfo valueForKey: SearchTermKey]];
}

- (void) fetchImageForSearchTerm: (NSString *) searchTerm tweetId: (NSString *) tweetId
{
    if(self.tweetToRequest == nil)
    {
        self.tweetToRequest = [NSMutableDictionary dictionary];
    }
    
    //MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [self.tweetToRequest setValue: movieRequest forKey: tweetId];
    
    //[movieRequest startWithSearchTerm: searchTerm];
}


@end

NSString * const TweetPicsCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicsKey = @"TweetPicsKey";
