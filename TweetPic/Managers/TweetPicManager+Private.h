
@class Tweet;

@interface TweetPicManager()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) TweetRequest *tweetRequest;

- (void) didEnterSearchTerm: (NSNotification *) notification;
- (void) fetchMovieForTweet: (Tweet *) tweet;
- (void) postNotificationForTweetPic: (TweetPic *) tweetPic;

@end
