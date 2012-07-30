
#import <UIKit/UIKit.h>

/// A custom UITableViewCell used to display a TweetPic.
/// The TweetPic's image is display in the UIImageView,
/// the text of the tweet in the 'tweetLabel' UILable, and the date of the
/// TweetPic's tweet in the 'dateLabel' UILabel.
///
@interface TweetPicCell : UITableViewCell

/// The label used to display the text of the TweetPic's tweet.
@property (nonatomic, assign) IBOutlet UILabel *tweetLabel;

/// The label used to display the date of the TweetPic's tweet.
@property (nonatomic, assign) IBOutlet UILabel *dateLabel;

/// The image view used to display the TweetPic's image.
@property (nonatomic, assign) IBOutlet UIImageView *imageView;

@end
