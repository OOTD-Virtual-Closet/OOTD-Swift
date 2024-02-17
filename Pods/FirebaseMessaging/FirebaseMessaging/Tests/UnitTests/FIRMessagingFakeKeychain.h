/*
 * Copyright 2021 Google LLC
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

#import <Foundation/Foundation.h>

#import "FirebaseMessaging/Sources/Token/FIRMessagingAuthKeychain.h"

@interface FIRMessagingFakeKeychain : FIRMessagingAuthKeychain

// Flags to simulate problems when reading from or writing to Keychain.
// By default you can always read/write to the Keychain.
@property(nonatomic, readwrite, assign) BOOL cannotReadFromKeychain;
@property(nonatomic, readwrite, assign) BOOL cannotWriteToKeychain;

@end
