
#import "MovieRequest.h"
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
    if([request isKindOfClass:[TweetRequest class]])
    {
        NSArray *results = [json valueForKey:@"results"];
        
        for(NSDictionary *result in results)
        {
            NSString *tweet = [result valueForKey:@"text"];
            NSString *tweetId = [result valueForKey: @"id_str"];
            NSLog(@"Tweet: %@", tweet);
            
            Tweet *newTweet = [[Tweet alloc] initWithTweetId: tweetId tweet: tweet];
            
            if(self.tweets == nil)
            {
                self.tweets = [NSMutableArray arrayWithCapacity:[result count]];
            }
            
            [self.tweets addObject:newTweet];
        }
        
        [self fetchImageForTweet:[self.tweets lastObject]];
    }
    else if([request isKindOfClass:[MovieRequest class]])
    {
        Tweet *tweet =  [self.tweets lastObject];
        UIImage *image = nil;
        
        NSArray *movies = [json valueForKey:@"movies"];
        if([movies count] > 0)
        {
            NSDictionary *movie = [movies objectAtIndex:0];
            NSDictionary *posters = [movie valueForKey:@"posters"];
            NSURL *posterURL = [NSURL URLWithString:[posters valueForKey:@"thumbnail"]];
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: posterURL]];
        }
        else
        {
            image = [UIImage imageNamed:@"beer.jpg"];
        }
        
        TweetPic *tweetPic = [[TweetPic alloc] initWithTweet:tweet.tweet image:image];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tweetPic
                                                             forKey:TweetPicKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:TweetPicCreatedNotification 
                                                            object:self 
                                                          userInfo:userInfo];
        
        [self.tweets removeLastObject];
        
        if([self.tweets count] > 0)
        {
            [self performSelector: @selector(fetchImageForTweet:) withObject:[self.tweets lastObject] afterDelay:0.0f];
        }
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

- (void) fetchImageForTweet: (Tweet *) tweet
{
    NSLog(@"Fetching image for tweet: %@", tweet.tweetId);
    
    self.movieRequest = [[MovieRequest alloc] init];
    self.movieRequest.delegate = self;
    NSString *searchTerm = [tweet longestWordInTweet];
    [self.movieRequest startWithSearchTerm: searchTerm];
}


@end

NSString * const TweetPicCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicsCreatedNotification = @"TweetPicsCreated";
NSString * const TweetPicsKey = @"TweetPicsKey";
NSString * const TweetPicKey = @"TweetPicKey";
