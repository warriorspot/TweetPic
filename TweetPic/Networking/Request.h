
#import <Foundation/Foundation.h>

@protocol RequestDelegate;

@interface Request : NSObject

@property (readonly) BOOL active;
@property (nonatomic, assign) id delegate;

- (void) start;
- (void) stop;

@end

@protocol RequestDelegate

@optional
- (void) request: (Request *) request didSucceed: (NSDictionary *) json;
- (void) request: (Request *) request didFailWithError: (NSError *) error;

@end