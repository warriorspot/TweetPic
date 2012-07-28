
#import "Tweet.h"
#import "TweetPic.h"

@implementation TweetPic

@synthesize date;
@synthesize image;
@synthesize tweet;

- (id) init
{
    return [self initWithTweet:@"Hello, World!" image:[UIImage imageNamed:@"beer.jpg"] date: [NSDate date]];
}

- (id) initWithTweet:(NSString *)newTweet image:(UIImage *)newImage date: (NSDate *) newDate
{
    self = [super init];
    if(self)
    {
        date = newDate;
        image = newImage;
        tweet = newTweet;
    }
    
    return self;
}

- (NSComparisonResult) compareByDate: (TweetPic *) otherTweetPic
{
    return [self.date compare: otherTweetPic.date];
}

- (NSComparisonResult) compareByTweet: (TweetPic *) otherTweetPic
{
    return [self.tweet caseInsensitiveCompare:otherTweetPic.tweet];
}

@end
