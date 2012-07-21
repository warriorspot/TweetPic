
#import "MovieRequest.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"
#import "TweetRequest.h"

@implementation TweetPicManager

@synthesize movieRequest;
@synthesize tweetRequest;

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

- (void) request:(Request *)request didSucceed:(NSDictionary *)json
{
    
}

#pragma mark - private methods

- (void) didEnterSearchTerm: (NSNotification *) notification
{
    if(self.movieRequest.active || self.tweetRequest.active)
    {
        return;
    }
    
    self.tweetRequest = [[TweetRequest alloc] init];
    [self.tweetRequest startWithSearchTerm:[notification.userInfo valueForKey: SearchTermKey]];
}

@end

NSString * const TweetPicCreatedNotification = @"TweetPicCreated";
NSString * const TweetPicKey = @"TweetPicKey";