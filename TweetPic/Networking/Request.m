
#import "Request.h"
#import "SimpleRESTRequest.h"

@implementation Request

@synthesize delegate;
@synthesize active;

#pragma mark - instance methods

- (void) start
{
    // Implement in subclass
}

- (void) stop
{
    // Implement in subclass
}

@end
