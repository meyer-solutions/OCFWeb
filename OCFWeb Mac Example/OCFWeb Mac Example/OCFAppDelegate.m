#import "OCFAppDelegate.h"
#import <OCFWeb/OCFWeb.h>


@interface OCFAppDelegate ()

@property (nonatomic, strong) OCFWebApplication *app;
@property (nonatomic, strong) NSMutableArray *persons; // contains NSDictionary instances

@end

@implementation OCFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.persons = [@[ [@{ @"id" : @"1", @"firstName" : @"Christian", @"lastName" : @"Kienle" } mutableCopy],
                    [@{ @"id" : @"2", @"firstName" : @"Amin", @"lastName" : @"Negm-awad" } mutableCopy],
                    [@{ @"id" : @"3", @"firstName" : @"Bill", @"lastName" : @"Gates" } mutableCopy] ] mutableCopy];
    
    self.app = [OCFWebApplication new];
    
    self.app[@"GET"][@"/persons"]  = ^(OCFRequest *request) {
        request.respondWith([OCFMustache newMustacheWithName:@"Persons" object:@{@"persons" : self.persons}]);
    };
    
    self.app[@"GET"][@"/persons/:id"]  = ^(OCFRequest *request) {
        NSString *personID = request.parameters[@"id"];
        
        // Find the person
        for(NSDictionary *person in self.persons) {
            if([person[@"id"] isEqualToString:personID]) {
                request.respondWith([OCFMustache newMustacheWithName:@"PersonDetail" object:person]);
                return; // person found
            }
        }
        request.respondWith(@"Error: No Person found");
    };
    
    self.app[@"POST"][@"/persons"]  = ^(OCFRequest *request) {
        NSMutableDictionary *person = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        person[@"id"] = [@(self.persons.count + 1) stringValue];
        [self.persons addObject:person];
        
        request.respondWith([request redirectedTo:@"/persons"]);
    };
    
    self.app[@"PUT"][@"/persons/:id"]  = ^(OCFRequest *request) {
        NSString *personID = request.parameters[@"id"];
        for(NSMutableDictionary *person in self.persons) {
            if([person[@"id"] isEqualToString:personID]) {
                [person setValuesForKeysWithDictionary:request.parameters];
                request.respondWith([request redirectedTo:@"/persons"]);
                return; // person updated
            }
        }
        request.respondWith(@"Error: No Person found");
    };
    
    [self.app run];
    
    NSString *address = [NSString stringWithFormat:@"http://127.0.0.1:%lu/persons", self.app.port];
    NSURL *result = [NSURL URLWithString:address];
    [[NSWorkspace sharedWorkspace] openURL:result];
}


@end
