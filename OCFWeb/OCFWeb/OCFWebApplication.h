// The MIT License (MIT)
// Copyright (c) 2013 Objective-Cloud (chris@objective-cloud.com)
// https://github.com/Objective-Cloud/OCFWeb

#import <Foundation/Foundation.h>

@class OCFRequest;
@class GRMustacheTemplateRepository;
@protocol OCFWebApplicationDelegate;

typedef void(^OCFWebApplicationRequestHandler)(OCFRequest *request);

@interface OCFWebApplication : NSObject

#pragma mark - Creating an Application
// This initializer is meant to be for testing purposes only.
// The reason is that OCFWebApplication needs to know the bundle of the enclosing
// application to that it can find the templates for the Mustache template engine.
// You should have no need to use this initializer at all. Using -init is good enough.
- (instancetype)initWithBundle:(NSBundle *)bundle;

#pragma mark - Properties
@property (nonatomic, weak) id<OCFWebApplicationDelegate> delegate;
@property (nonatomic, readonly) NSUInteger port;

#pragma mark - Adding Handlers
- (void)handle:(NSString *)methodPattern requestsMatching:(NSString *)pathPattern withBlock:(OCFWebApplicationRequestHandler)requestHandler;

#pragma mark - Controlling the Application
- (void)run;
- (void)runOnPort:(NSUInteger)port;
- (void)stop;

- (void)setTemplateRepository:(GRMustacheTemplateRepository*)repo;

@end

#pragma mark - Subscripting
@interface OCFWebApplication ()
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
@end