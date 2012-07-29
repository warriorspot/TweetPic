
#import <UIKit/UIKit.h>

@class TweetPicManager;

/// AppDelegate for TweetPic.  Creates the initial TweetPicViewController
/// and sets it as the root view controller.  Creates an instance of
/// TweetPicManager to respond to the user entering a Twitter search term.
///
@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// The main application window
@property (strong, nonatomic) UIWindow *window;

/// This instance is responsible for querying Twitter and RottenTomatoes
/// and generating TweetPic instances.
@property (nonatomic, strong) TweetPicManager *tweetPicManager;

@end
