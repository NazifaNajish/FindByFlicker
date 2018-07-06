//
//  FindByFlickrUITests.m
//  FindByFlickrUITests
//
//  Created by Nazifa Najish on 7/6/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FindByFlickrUITests : XCTestCase

@end

@implementation FindByFlickrUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    // Click On textField
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *queryField = app.textFields[@"Query"];
    [queryField tap];
    
    // Enter value in textField
    UIPasteboard.generalPasteboard.string = @"Kittens";
    [queryField doubleTap];
    [[app.menuItems elementBoundByIndex:0] tap];
    [NSThread sleepForTimeInterval:1.0];

    // Tap on Search Button
    XCUIElement *searchButton = app.buttons[@"Search"];
    [searchButton tap];
    
    // Swipe ScrollView
    [NSThread sleepForTimeInterval:4.0];
    XCUIElement *collection = [app.collectionViews elementBoundByIndex:0]; 
    [collection swipeDown];
    
    [NSThread sleepForTimeInterval:1.0];
    [collection swipeUp];
    
    // Swipe more
    for (int i=0; i < 10; i++) {
        [NSThread sleepForTimeInterval:0.1];
        [collection swipeUp];
    }

}

@end
