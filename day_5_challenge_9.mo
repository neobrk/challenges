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

actor {
  // Challenge 9 : In a new file, copy and paste the functionnalities you've created in
  // challenges 2 to 5. This time the hashmap and all records should be preserved accross
  // upgrades.

  // Challenge 2 : Create an HashMap called favoriteNumber where the keys are Principal and the
  // value are Nat.

  stable var favoriteNumberEntries : [(Principal, Nat)] = [];
  let favoriteNumber = HashMap.fromIter<Principal, Nat>(favoriteNumberEntries.vals(), 1, Principal.equal, Principal.hash);
 

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

  system func preupgrade() {
    favoriteNumberEntries := Iter.toArray(favoriteNumber.entries());
  };

  system func postupgrade() {
    favoriteNumberEntries := [];
  };

};
