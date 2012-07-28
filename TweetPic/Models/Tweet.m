
#import "Tweet.h"

@implementation Tweet

@synthesize date;
@synthesize tweetId;
@synthesize tweet;

- (id) initWithTweetId: (NSString *) newTweetId tweet: (NSString *) newTweet date:(NSDate *) newDate
{
    self = [super init];
    if(self)
    {
        date = newDate;
        tweetId = newTweetId;
        tweet = newTweet;
    }
    
    return self;
}

@end
