
#import <UIKit/UIKit.h>

/// TweetPicView controller is responsible for allowing the user to enter a Twitter search
/// term, and displaying and sorting the resulting TweetPics (created by an instance of TweetPicManager) in a table view.
///
/// Each TweetPic received is added in sorted order (according to the
/// current selection of the segmented control) to the internal array,
/// and table view data is reloaded.
/// 
/// When the user enters a search term in the search bar, a DidEnterSearchTermNotification
/// is posted to inform interested objects (i.e. TweetPicManager) of the search term.
/// The search term is sent in the notification userInfo dictionary and is
/// accessible via the SearchTermKey key.
/// 
/// When the keyboard is visible, it can be dismissed by tapping anywhere outside
/// of the UISearchBar.
/// 
/// The mode of sorting can be changed by selecting a new segment in the UISegmentedControl.
/// The sorting is done immediately and the table's data is reloaded.
/// 
/// Notifications
/// 
/// registers for:
/// 
/// TweetPicCreatedNotification
/// TweetPicErrorNotification
/// TweetPicsCreatedNotification
/// UIKeyboardDidShowNotification
/// UIKeyboardDidHideNotification
/// 
/// sends:
/// 
/// DidEnterSearchTermNotification
/// 
/// Delegation
/// 
/// is delegate of:
/// 
/// UISearchBar
/// UITableView
/// UIAlertView
/// 
/// delegates:
/// 
/// none

@interface TweetPicViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

/// Search bar for entering a keyword used to query Twitter
@property (nonatomic, assign) IBOutlet UISearchBar *tweetSearchBar;

/// The table view used to display TweetPics
@property (nonatomic, assign) IBOutlet UITableView *tweetPicTableView;

/// Select the method of sorting the contents of the table view
@property (nonatomic, assign) IBOutlet UISegmentedControl *sortingControl;

/// A label showing the current count of TweetPics created for the current
/// search term.
@property (nonatomic, assign) IBOutlet UILabel *tweetPicCountLabel;

/// The data source for the table view.  Contains TweetPic instances.
@property (nonatomic, strong) NSMutableArray *tweetPics;

@end

/// Notification posted when the user selects the "Search"  button after
/// entering a search term in the search bar.
extern NSString * const DidEnterSearchTermNotification;

/// The key used to access the search term in the userInfo dictionary
/// of a DidEnterSearchTermNotification.
extern NSString * const SearchTermKey;
