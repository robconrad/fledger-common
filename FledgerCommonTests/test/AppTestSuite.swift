//
// Created by Robert Conrad on 5/10/15.
// Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import FledgerCommon
#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif

class AppTestSuite: XCTestCase {

    override class func setUp() {
        super.setUp()

        // reinitialize all services on test suite initialization
        ServiceBootstrap.preRegister()
        do {
            try PFUser.logInWithUsername("test", password: "test")
        }
        catch {
            // sigh
        }
        ServiceBootstrap.register()
    }

}
