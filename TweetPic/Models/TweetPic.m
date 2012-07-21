
#import "TweetPic.h"

@implementation TweetPic

@synthesize image;
@synthesize tweet;

- (id) init
{
    return [self initWithTweet:@"Hello, World!" image:[UIImage imageNamed:@"beer.jpg"]];
}

- (id) initWithTweet:(NSString *)newTweet image:(UIImage *)newImage
{
    self = [super init];
    if(self)
    {
        image = newImage;
        tweet = newTweet;
    }
    
    return self;
}

@end
