
#import <Foundation/Foundation.h>

@protocol RequestDelegate;

@interface Request : NSObject

@property (readonly) BOOL active;
@property (nonatomic, assign) id delegate;

- (void) startWithSearchTerm: (NSString *) searchTerm;
- (void) stop;

@end

@protocol RequestDelegate

@optional
- (void) request: (Request *) request didSucceedWithObject: (id) object;
- (void) request: (Request *) request didFailWithError: (NSError *) error;

@end