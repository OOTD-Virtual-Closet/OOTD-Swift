/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <TargetConditionals.h>
#if !TARGET_OS_MACCATALYST && !SWIFT_PACKAGE
// Skip keychain tests on Catalyst and swift package

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "FirebaseMessaging/Sources/Token/FIRMessagingAuthKeychain.h"
#import "FirebaseMessaging/Sources/Token/FIRMessagingCheckinPreferences.h"
#import "FirebaseMessaging/Sources/Token/FIRMessagingTokenInfo.h"

static NSString *const kFIRMessagingTestKeychainId = @"com.google.iid-tests";

static NSString *const kAuthorizedEntity = @"test-audience";
static NSString *const kScope = @"test-scope";

static NSString *const kToken1 =
    @"dOr37DpYQ9M:APA91bE5aQ2expDEmoSNDDrZqS6drAz2V-GHJHEsa-qVdlHXVSlWpUsK-Ta6Oe1QsVSLovL7_"
    @"rbm8GNnP7XPfwjtDQrjxYS1BdtxHdVVnQKuxlF3Z0QOwL380l1e1Fz91PX5b77XKj0FIyqzX1z0uJc0-pM6YcaPGg";
#if TARGET_OS_IOS || TARGET_OS_TV
static NSString *const kAuthID = @"test-auth-id";
static NSString *const kSecret = @"test-secret";
static NSString *const kToken2 = @"c8oEXUYIl3s:APA91bHtJMs_dZ2lXYXIcwsC47abYIuWhEJ_CshY2PJRjVuI_"
                                 @"H659iYUwfmNNghnZVkCmeUdKDSrK8xqVb0PVHxyAW391Ynp2NchMB87kJWb3BS0z"
                                 @"ud6Ej_xDES_oc353eFRvt0E6NXefDmrUCpBY8y89_1eVFFfiA";
#endif
static NSString *const kFirebaseAppID = @"abcdefg:ios:QrjxYS1BdtxHdVVnQKuxlF3Z0QO";

static NSString *const kBundleID1 = @"com.google.fcm.dev";
static NSString *const kBundleID2 = @"com.google.abtesting.dev";

@interface FIRMessagingAuthKeychain (ExposedForTest)

@property(nonatomic, copy)
    NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSArray<NSData *> *> *>
        *cachedKeychainData;
- (NSMutableDictionary *)keychainQueryForService:(NSString *)service account:(NSString *)account;

@end

@interface FIRMessagingAuthKeychainTest : XCTestCase

@end

@implementation FIRMessagingAuthKeychainTest

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testKeyChainNoCorruptionWithUniqueAccount {
// macOS only support one service and one account.
#if TARGET_OS_IOS || TARGET_OS_TV
  XCTestExpectation *noCurruptionExpectation =
      [self expectationWithDescription:@"No corruption between different accounts."];
  // Create a keychain with a service and a unique account
  NSString *service = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];
  NSString *account1 = kBundleID1;
  NSData *tokenInfoData1 = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                         scope:kScope
                                                         token:kToken1];
  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];
  __weak FIRMessagingAuthKeychain *weakKeychain = keychain;
  [keychain setData:tokenInfoData1
         forService:service
            account:account1
            handler:^(NSError *error) {
              XCTAssertNil(error);
              // Create another keychain with the same service but different account.
              NSString *account2 = kBundleID2;
              NSData *tokenInfoData2 = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                                     scope:kScope
                                                                     token:kToken2];
              [weakKeychain
                     setData:tokenInfoData2
                  forService:service
                     account:account2
                     handler:^(NSError *error) {
                       XCTAssertNil(error);
                       // Now query the token and compare, they should not corrupt
                       // each other.
                       NSData *data1 = [weakKeychain dataForService:service account:account1];
                       FIRMessagingTokenInfo *tokenInfo1 =
                           [NSKeyedUnarchiver unarchivedObjectOfClass:FIRMessagingTokenInfo.class
                                                             fromData:data1
                                                                error:&error];
                       XCTAssertNil(error);
                       XCTAssertEqualObjects(kToken1, tokenInfo1.token);

                       NSData *data2 = [weakKeychain dataForService:service account:account2];
                       FIRMessagingTokenInfo *tokenInfo2 =
                           [NSKeyedUnarchiver unarchivedObjectOfClass:FIRMessagingTokenInfo.class
                                                             fromData:data2
                                                                error:&error];
                       XCTAssertNil(error);
                       XCTAssertEqualObjects(kToken2, tokenInfo2.token);
                       // Also check the cache data.
                       XCTAssertEqual(weakKeychain.cachedKeychainData.count, 1);
                       XCTAssertEqual(weakKeychain.cachedKeychainData[service].count, 2);
                       XCTAssertEqualObjects(
                           weakKeychain.cachedKeychainData[service][account1].firstObject,
                           tokenInfoData1);
                       XCTAssertEqualObjects(
                           weakKeychain.cachedKeychainData[service][account2].firstObject,
                           tokenInfoData2);

                       // Check wildcard query
                       NSArray *results = [weakKeychain itemsMatchingService:service account:@"*"];
                       XCTAssertEqual(results.count, 2);

                       // Clean up keychain at the end
                       [weakKeychain removeItemsMatchingService:service
                                                        account:@"*"
                                                        handler:^(NSError *_Nonnull error) {
                                                          XCTAssertNil(error);
                                                          [noCurruptionExpectation fulfill];
                                                        }];
                     }];
            }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
#endif
}

- (void)testKeyChainNoCorruptionWithUniqueService {
#if TARGET_OS_IOS || TARGET_OS_TV
  XCTestExpectation *noCurruptionExpectation =
      [self expectationWithDescription:@"No corruption between different services."];
  // Create a keychain with a service and a unique account
  NSString *service1 = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];
  NSString *account = kBundleID1;
  NSData *tokenData = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                    scope:kScope
                                                    token:kToken1];
  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];
  __weak FIRMessagingAuthKeychain *weakKeychain = keychain;
  [keychain
         setData:tokenData
      forService:service1
         account:account
         handler:^(NSError *error) {
           XCTAssertNil(error);
           // Store a checkin info using the same keychain account, but different service.
           NSString *service2 = @"com.google.iid.checkin";
           FIRMessagingCheckinPreferences *preferences =
               [[FIRMessagingCheckinPreferences alloc] initWithDeviceID:kAuthID
                                                            secretToken:kSecret];
           NSString *checkinKeychainContent = [preferences checkinKeychainContent];
           NSData *checkinData = [checkinKeychainContent dataUsingEncoding:NSUTF8StringEncoding];

           [weakKeychain
                  setData:checkinData
               forService:service2
                  account:account
                  handler:^(NSError *error) {
                    XCTAssertNil(error);
                    // Now query the token and compare, they should not corrupt
                    // each other.
                    NSData *data1 = [weakKeychain dataForService:service1 account:account];
                    FIRMessagingTokenInfo *tokenInfo1 =
                        [NSKeyedUnarchiver unarchivedObjectOfClass:FIRMessagingTokenInfo.class
                                                          fromData:data1
                                                             error:&error];
                    XCTAssertNil(error);
                    XCTAssertEqualObjects(kToken1, tokenInfo1.token);

                    NSData *data2 = [weakKeychain dataForService:service2 account:account];
                    NSString *checkinKeychainContent =
                        [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    FIRMessagingCheckinPreferences *checkinPreferences =
                        [FIRMessagingCheckinPreferences
                            preferencesFromKeychainContents:checkinKeychainContent];
                    XCTAssertEqualObjects(checkinPreferences.secretToken, kSecret);
                    XCTAssertEqualObjects(checkinPreferences.deviceID, kAuthID);

                    NSArray *results = [weakKeychain itemsMatchingService:@"*" account:account];
                    XCTAssertEqual(results.count, 2);
                    // Also check the cache data.
                    XCTAssertEqual(weakKeychain.cachedKeychainData.count, 2);
                    XCTAssertEqualObjects(
                        weakKeychain.cachedKeychainData[service1][account].firstObject, tokenData);
                    XCTAssertEqualObjects(
                        weakKeychain.cachedKeychainData[service2][account].firstObject,
                        checkinData);

                    // Clean up keychain at the end
                    [weakKeychain removeItemsMatchingService:@"*"
                                                     account:@"*"
                                                     handler:^(NSError *_Nonnull error) {
                                                       XCTAssertNil(error);
                                                       [noCurruptionExpectation fulfill];
                                                     }];
                  }];
         }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
#endif
}

// Skip keychain tests on Catalyst and macOS. Tests are skipped because they
// involve interactions with the keychain that require a provisioning profile.
// See go/firebase-macos-keychain-popups for more details.
#if !TARGET_OS_MACCATALYST && !TARGET_OS_OSX

- (void)testQueryCachedKeychainItems {
  XCTestExpectation *addItemToKeychainExpectation =
      [self expectationWithDescription:@"Test added item should be cached properly"];
  // A wildcard query should return empty data when there's nothing in keychain
  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];
  id keychainMock = OCMPartialMock(keychain);

  NSArray *result = [keychain itemsMatchingService:@"*" account:@"*"];
  XCTAssertEqual(result.count, 0);

  // Create a keychain item
  NSString *service = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];
  NSString *account = kBundleID1;
  NSData *tokenData = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                    scope:kScope
                                                    token:kToken1];
  __weak FIRMessagingAuthKeychain *weakKeychain = keychain;
  __weak id weakKeychainMock = keychainMock;
  [keychain setData:tokenData
         forService:service
            account:account
            handler:^(NSError *error) {
              XCTAssertNil(error);

              // Now if we clean the cache
              [weakKeychain.cachedKeychainData removeAllObjects];
              // Then query the item should fetch from keychain.
              NSData *data = [weakKeychain dataForService:service account:account];
              XCTAssertEqualObjects(data, tokenData);
              // Verify we fetch from keychain by calling to get the query
              OCMVerify([weakKeychainMock keychainQueryForService:service account:account]);
              // Cache should now have the query item
              XCTAssertEqualObjects(weakKeychain.cachedKeychainData[service][account].firstObject,
                                    tokenData);
              // Wildcard query should simply return the results without cache it
              data = [weakKeychain dataForService:@"*" account:account];
              XCTAssertEqualObjects(data, tokenData);
              // Cache should not have wildcard query entry
              XCTAssertNil(weakKeychain.cachedKeychainData[@"*"]);

              // Assume keychain has empty service entry
              [weakKeychain.cachedKeychainData setObject:[@{} mutableCopy] forKey:service];
              // Query the item
              data = [weakKeychain dataForService:service account:account];
              XCTAssertEqualObjects(data, tokenData);
              // Cache should have the query item.
              XCTAssertEqualObjects(weakKeychain.cachedKeychainData[service][account].firstObject,
                                    tokenData);

              // Clean up keychain at the end
              [weakKeychain removeItemsMatchingService:@"*"
                                               account:@"*"
                                               handler:^(NSError *_Nonnull error) {
                                                 XCTAssertNil(error);
                                                 [addItemToKeychainExpectation fulfill];
                                               }];
            }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testCachedKeychainOverwrite {
  XCTestExpectation *overwriteCachedKeychainExpectation =
      [self expectationWithDescription:@"Test the cached keychain item is overwrite properly"];

  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];

  // Set the cache a different data under the same service but different account
  NSData *data = [[NSData alloc] init];
  NSString *service = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];

  [keychain.cachedKeychainData setObject:[@{kBundleID2 : data} mutableCopy] forKey:service];

  // Create a keychain item
  NSString *account = kBundleID1;
  NSData *tokenData = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                    scope:kScope
                                                    token:kToken1];
  __weak FIRMessagingAuthKeychain *weakKeychain = keychain;
  [keychain setData:tokenData
         forService:service
            account:account
            handler:^(NSError *error) {
              XCTAssertNil(error);

              // Query the item should fetch from keychain because no entry under the same
              // service and account.
              NSData *data = [weakKeychain dataForService:service account:account];
              XCTAssertEqualObjects(data, tokenData);

              // Cache should now have the query item
              XCTAssertEqualObjects(weakKeychain.cachedKeychainData[service][account].firstObject,
                                    tokenData);

              // Clean up keychain at the end
              [weakKeychain removeItemsMatchingService:@"*"
                                               account:@"*"
                                               handler:^(NSError *_Nonnull error) {
                                                 XCTAssertNil(error);
                                                 [overwriteCachedKeychainExpectation fulfill];
                                               }];
            }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testSetKeychainItemShouldDeleteOldEntry {
  XCTestExpectation *overwriteCachedKeychainExpectation = [self
      expectationWithDescription:@"Test keychain entry should be deleted before adding a new one"];

  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];

  // Assume keychain had a old entry under the same service and account.
  // Now if we set the cache a different data under the same service
  NSData *oldData = [[NSData alloc] init];
  NSString *service = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];
  NSString *account = kBundleID1;
  [keychain.cachedKeychainData setObject:[@{account : oldData} mutableCopy] forKey:service];
  // add a new keychain item
  NSData *tokenData = [self tokenDataWithAuthorizedEntity:kAuthorizedEntity
                                                    scope:kScope
                                                    token:kToken1];
  __weak FIRMessagingAuthKeychain *weakKeychain = keychain;
  [keychain setData:tokenData
         forService:service
            account:account
            handler:^(NSError *error) {
              XCTAssertNil(error);

              // Cache should now have the updated item
              XCTAssertEqualObjects(weakKeychain.cachedKeychainData[service][account].firstObject,
                                    tokenData);

              // Clean up keychain at the end
              [weakKeychain removeItemsMatchingService:@"*"
                                               account:@"*"
                                               handler:^(NSError *_Nonnull error) {
                                                 XCTAssertNil(error);
                                                 [overwriteCachedKeychainExpectation fulfill];
                                               }];
            }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testInvalidQuery {
  XCTestExpectation *invalidKeychainQueryExpectation =
      [self expectationWithDescription:@"Test invalid keychain query"];

  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];

  NSData *data = [[NSData alloc] init];
  [keychain setData:data
         forService:@"*"
            account:@"*"
            handler:^(NSError *error) {
              XCTAssertNotNil(error);
              [invalidKeychainQueryExpectation fulfill];
            }];
  [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testQueryAndAddEntry {
  FIRMessagingAuthKeychain *keychain =
      [[FIRMessagingAuthKeychain alloc] initWithIdentifier:kFIRMessagingTestKeychainId];

  // Set the cache a different data under the same service but different account
  NSData *data = [[NSData alloc] init];
  NSString *service = [NSString stringWithFormat:@"%@:%@", kAuthorizedEntity, kScope];
  NSString *account1 = kBundleID1;

  [keychain.cachedKeychainData setObject:[@{account1 : data} mutableCopy] forKey:service];
  // Now account2 doesn't exist in cache
  NSString *account2 = kBundleID2;
  XCTAssertNil(keychain.cachedKeychainData[service][account2]);
  // Query account2
  XCTAssertNil([keychain dataForService:service account:account2]);
  // Service and account2 should exist in cache.
  XCTAssertNotNil(keychain.cachedKeychainData[service][account2]);
}

#endif

#pragma mark - helper function
- (NSData *)tokenDataWithAuthorizedEntity:(NSString *)authorizedEntity
                                    scope:(NSString *)scope
                                    token:(NSString *)token {
  FIRMessagingTokenInfo *tokenInfo =
      [[FIRMessagingTokenInfo alloc] initWithAuthorizedEntity:authorizedEntity
                                                        scope:scope
                                                        token:token
                                                   appVersion:@"1.0"
                                                firebaseAppID:kFirebaseAppID];
  NSError *error;
  NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:tokenInfo
                                          requiringSecureCoding:YES
                                                          error:&error];
  XCTAssertNil(error);
  return archive;
}
@end

#endif  // TARGET_OS_MACCATALYST
