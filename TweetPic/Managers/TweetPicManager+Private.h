

@interface TweetPicManager()

@property (nonatomic, strong) NSMutableDictionary *tweetToRequest;

- (void) didEnterSearchTerm: (NSNotification *) notification;
- (void) fetchImageForTweetId: (NSString *) tweetId;
- (NSString *) longestWordInTweet: (NSString *) tweet;

@end
