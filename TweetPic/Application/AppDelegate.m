
#import "AppDelegate.h"
#import "TweetPicManager.h"
#import "TweetPicViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tweetPicManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tweetPicManager = [[TweetPicManager alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    TweetPicViewController *tweetPicViewController = [[TweetPicViewController alloc] initWithNibName:@"TweetPicView" bundle:nil];
    self.window.rootViewController = tweetPicViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

@end
