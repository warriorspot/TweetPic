
#import <UIKit/UIKit.h>

@interface TweetPicViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UISearchBar *tweetSearchBar;
@property (nonatomic, strong) IBOutlet UITableView *tweetPicTableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *tweetPics;

@end

extern NSString * const DidEnterSearchTermNotification;
extern NSString * const SearchTermKey;
