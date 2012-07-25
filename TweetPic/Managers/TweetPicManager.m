
#import "MovieRequest.h"
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
        NSLog(@"Tweet: %@", tweet);
        
        TweetPic *tweetPic = [[TweetPic alloc] initWithTweet:tweet 
                                                       image:[UIImage imageNamed:@"beer.jpg"]];
        [tweetPics addObject:tweetPic];
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

- (void) fetchImageForTweetId: (NSString *) tweetId
{
    if(self.tweetToRequest == nil)
    {
        self.tweetToRequest = [NSMutableDictionary dictionary];
    }
    
    MovieRequest *movieRequest = [[MovieRequest alloc] init];
}

- (NSString *) longestWordInTweet: (NSString *) tweet
{
    if(tweet == nil || [tweet length] == 0)
    {
        return nil;
    }
    
    NSString *longestWord = @"";
    NSArray *components = [tweet componentsSeparatedByString: @" "];
    
    for(NSString *string in components)
    {
        if([string length] > [longestWord length])
        {
            longestWord = string;
        }
    }
    
    return longestWord;
}

@end

NSString * const TweetPicsCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicsKey = @"TweetPicsKey";
