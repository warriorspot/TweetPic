
@interface TweetPicViewController()

@property NSUInteger tweetPicCount;

- (void) showMessageWithTitle: (NSString *) title message: (NSString *) message;

- (void) tweetPicErrorNotification: (NSNotification *) notification;

- (void) tweetPicNotification: (NSNotification *) notification;

- (void) tweetPicsCreatedNotification: (NSNotification *) notification;

@end