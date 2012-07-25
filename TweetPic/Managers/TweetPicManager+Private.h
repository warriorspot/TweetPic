

@interface TweetPicManager()

@property (nonatomic, strong) NSMutableDictionary *tweetToRequest;

- (void) didEnterSearchTerm: (NSNotification *) notification;
- (void) fetchImageForSearchTerm: (NSString *) searchTerm tweetId: (NSString *) tweetId;

@end
