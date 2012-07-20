
#import "AppDelegate.h"
#import "TweetPicViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    TweetPicViewController *tweetPicViewController = [[TweetPicViewController alloc] initWithNibName:@"TweetPicView" bundle:nil];
    self.window.rootViewController = tweetPicViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

@end
