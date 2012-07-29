
#import "Tweet.h"

@implementation Tweet

@synthesize date;
@synthesize tweetId;
@synthesize tweet;

- (id) init
{
    return [self initWithTweetId:nil tweet:@"" date:[NSDate date]];
}

- (id) initWithTweetId: (NSString *) newTweetId
                 tweet: (NSString *) newTweet
                  date:(NSDate *) newDate
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

#pragma mark - instance methods

- (NSString *) description
{
    return [NSString stringWithFormat:@"id: %@ tweet: %@ date: %@",
             self.tweetId, self.tweet, [self.date description]];
}

@end
