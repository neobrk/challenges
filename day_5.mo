import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
// import day_5_withdraw "canister:day_5_withdraw";

actor {
  // Challenge 1 : Write a function is_anonymous that takes no arguments but returns true is
  // the caller is anonymous and false otherwise.
  public shared(msg) func is_anonymous () : async Bool {
    return (Text.equal(Principal.toText(msg.caller), "2vxsx-fae"));
  };


  // Challenge 2 : Create an HashMap called favoriteNumber where the keys are Principal and the
  // value are Nat.
  let favoriteNumber = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);


  // Challenge 3 : Write two functions :
  // - add_favorite_number that takes n of type Nat and stores this value in the HashMap where
  // the key is the principal of the caller. This function has no return value.
  // - show_favorite_number that takes no argument and returns n of type ?Nat, n is the
  // favorite number of the person as defined in the previous function or null if the person
  // hasn't registered.
  public shared(msg) func add_favorite_number_v1 (n : Nat) {
    favoriteNumber.put(msg.caller, n);
  };

  public shared(msg) func show_favorite_number () : async ?Nat {
    return favoriteNumber.get(msg.caller);
  };


  // Challenge 4 : Rewrite your function add_favorite_number so that if the caller has already
  // registered his favorite number, the value in memory isn't modified. This function will
  // return a text of type Text that indicates "You've already registered your number" in that
  // case and "You've successfully registered your number" in the other scenario.
  public shared(msg) func add_favorite_number (n : Nat) : async Text {
    switch (favoriteNumber.get(msg.caller)) {
      case(null) {
        favoriteNumber.put(msg.caller, n);
        return "You've successfully registered your number";
      };
      case(_) {
        return "You've already registered your number";
      };
    };
  };


  // Challenge 5 : Write two functions
  // update_favorite_number
  // delete_favorite_number
  public shared(msg) func update_favorite_number (n : Nat) : async Text {
    switch (favoriteNumber.get(msg.caller)) {
      case(null) {
        favoriteNumber.put(msg.caller, n);
        return "Your number has been set";
      };
      case(_) {
        favoriteNumber.put(msg.caller, n);
        return "Your number has been updated";
      };
    };
  };

  public shared(msg) func delete_favorite_number () : async Text {
    switch (favoriteNumber.get(msg.caller)) {
      case(null) {
        return "You haven't yet registered your number";
      };
      case(_) {
        favoriteNumber.delete(msg.caller);
        return "Your number has been deleted";
      };
    };
  };


  // Challenge 6 : Write a function deposit_cycles that allow anyone to deposit cycles into
  // the canister. This function takes no parameter but returns n of type Nat corresponding to
  // the amount of cycles deposited by the call.
  public func deposit_cycles() : async Nat {
    let received = Cycles.available();
    return Cycles.accept(received);
  };


  // Challenge 7 (hard ⚠️) : Write a function withdraw_cycles that takes a parameter n of type
  // Nat corresponding to the number of cycles you want to withdraw from the canister and send
  // it to caller asumming the caller has a callback called deposit_cycles()
  // Note : You need two canisters.
  // Note 2 : Don't do that in production without admin protection or your might be the target
  // of a cycle draining attack.
//  public func get_cycles() {
//    day_5_withdraw.withdraw_cycles(1000, deposit_cycles());
//  };
// [the above isn't working yet]


  // Challenge 8 : Rewrite the counter (of day 1) but this time the counter will be kept
  // accross ugprades. Also declare a variable of type **Nat¨¨ called version_number that will
  // keep track of how many times your canister has been upgraded.
  stable var counter : Nat = 0;
  stable var version_number : Nat = 0;

  public func increment_counter(n : Nat) : async Nat {
    counter := counter + n;
    return counter;
  };

  public func clear_counter() : async () {
    counter := 0;
  };

  system func postupgrade() {
    version_number += 1;
  };

};
