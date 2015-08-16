//
// Created by Robert Conrad on 5/10/15.
// Copyright (c) 2015 Robert Conrad. All rights reserved.
//

#if os(iOS)
import Parse
#elseif os(OSX)
import ParseOSX
#endif

public class ServiceBootstrap {

    private static var _registered = false

    // safe from multi-initialization
    public static func registered() -> Bool {
        if (!_registered) {
            register()
        }
        return _registered
    }
    
    public static func preRegister() {
        
        // Initialize Parse.
        Parse.setApplicationId("fjcMqJqBTJsHRsrDkuKk7wGuAMMTu1d4820IdBQg", clientKey: "hyiXQhwKd2aQvusxJuRliyxrKEhRx6Xx9gTndNaV")
        
        Services.register(ParseService.self, ParseServiceImpl())
        
    }

    // allows forced reinitialization
    public static func register() {
        
        // prerequisites to most services
        Services.register(DatabaseService.self, DatabaseServiceImpl(PFUser.currentUser()!.username!))

        // model services
        Services.register(ItemService.self, ItemServiceImpl())
        Services.register(AccountService.self, AccountServiceImpl())
        Services.register(TypeService.self, TypeServiceImpl())
        Services.register(GroupService.self, GroupServiceImpl())
        Services.register(LocationService.self, LocationServiceImpl())
        
        // secondary services
        Services.register(AggregateService.self, AggregateServiceImpl())

        _registered = true

    }

}

// sugared service locators
public func DatabaseSvc()      -> DatabaseService      { return Services.get(DatabaseService.self)     }
public func ParseSvc()         -> ParseService         { return Services.get(ParseService.self)        }
public func ItemSvc()          -> ItemService          { return Services.get(ItemService.self)         }
public func AccountSvc()       -> AccountService       { return Services.get(AccountService.self)      }
public func TypeSvc()          -> TypeService          { return Services.get(TypeService.self)         }
public func GroupSvc()         -> GroupService         { return Services.get(GroupService.self)        }
public func LocationSvc()      -> LocationService      { return Services.get(LocationService.self)     }
public func AggregateSvc()     -> AggregateService     { return Services.get(AggregateService.self)    }
