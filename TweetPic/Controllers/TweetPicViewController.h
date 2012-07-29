
#import <UIKit/UIKit.h>

@interface TweetPicViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

/// Search bar for entering a keyword used to query Twitter
@property (nonatomic, assign) IBOutlet UISearchBar *tweetSearchBar;

/// The table view used to display TweetPics
@property (nonatomic, assign) IBOutlet UITableView *tweetPicTableView;

/// 
@property (nonatomic, assign) IBOutlet UISegmentedControl *sortingControl;
@property (nonatomic, assign) IBOutlet UILabel *tweetPicCountLabel;
@property (nonatomic, strong) NSMutableArray *tweetPics;

@end

extern NSString * const DidEnterSearchTermNotification;
extern NSString * const SearchTermKey;
