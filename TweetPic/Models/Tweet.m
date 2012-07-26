
#import "Tweet.h"

@implementation Tweet

@synthesize tweetId;
@synthesize tweet;

- (id) initWithTweetId: (NSString *) newTweetId tweet: (NSString *) newTweet
{
    self = [super init];
    if(self)
    {
        tweetId = newTweetId;
        tweet = newTweet;
    }
    
    return self;
}

- (NSString *) longestWordInTweet
{
    NSString *longestWord = @"";
    
    NSArray *components = [tweet componentsSeparatedByString: @" "];
    
    for(NSString *string in components)
    {
        if([string length] > 0 && [string characterAtIndex: 0] == '@') continue;
        
        if([string length] > [longestWord length])
        {
            longestWord = string;
        }
    }
    
    return longestWord;
}

@end
