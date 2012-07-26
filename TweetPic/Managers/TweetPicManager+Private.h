
@class Tweet;

@interface TweetPicManager()

@property (nonatomic, strong) TweetRequest *tweetRequest;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) MovieRequest *movieRequest;

- (void) didEnterSearchTerm: (NSNotification *) notification;
- (void) fetchImageForTweet: (Tweet *) tweet;

@end
