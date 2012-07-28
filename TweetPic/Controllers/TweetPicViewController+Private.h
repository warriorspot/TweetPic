
@interface TweetPicViewController()

@property (nonatomic, assign) IBOutlet UIButton *dismissKeyboardButton;
@property NSUInteger tweetPicCount;

- (IBAction) dismissKeyboard:(id)sender;

- (void) keyboardDidHide: (NSNotification *) notification;

- (void) keyboardDidShow: (NSNotification *) notification;

- (void) showMessageWithTitle: (NSString *) title message: (NSString *) message;

- (void) tweetPicErrorNotification: (NSNotification *) notification;

- (void) tweetPicNotification: (NSNotification *) notification;

- (void) tweetPicsCreatedNotification: (NSNotification *) notification;

@end