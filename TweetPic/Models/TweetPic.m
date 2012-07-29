
#import "Tweet.h"
#import "TweetPic.h"

@interface TweetPic()
{
@private
    NSDateFormatter *dateFormatter;
}

@end

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

- (NSString *) dateString
{
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM y HH:mm:ss"];
    }
    
    return [dateFormatter stringFromDate:self.date];
}

@end
