import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor {
  // Challenge 1 : Write a private function swap that takes 3 parameters : a mutable array , an index j and an index i and returns the same array but where value at index i and index j have been swapped.
  func swap(array : [var Nat], j: Nat, i: Nat) : [var Nat] {
    let temp : Nat = array[j];
    array[j] := array[i];
    array[i] := temp;

    return array;
  };


  // Challenge 2 : Write a function init_count that takes a Nat n and returns an array [Nat] where value is equal to it's corresponding index.
  // Note : init_count(5) -> [0,1,2,3,4].
  // Note 2 : Do not use Array.append.
  public func init_count(n : Nat) : async [Nat] {
    let result : [Nat] = Array.tabulate<Nat>(n, func(index: Nat) : Nat { return index });
  };

  // Challenge 3 : Write a function seven that takes an array [Nat] and returns "Seven is found" if one digit of ANY number is 7. Otherwise this function will return "Seven not found".
  public func seven(array : [Nat]) : async Text {
    for (n in array.vals()) {
      if (_any_sevens(n)) {
        return "Seven is found";
      };
    };
    return "Seven not found";
  };

  func _any_sevens(n : Nat) : Bool {
    if (n < 10) {
      return (n == 7);
    } else {
      return _any_sevens(n / 10) or _any_sevens(n % 10);
    };
  };


  // Challenge 4 : Write a function nat_opt_to_nat that takes two parameters : n of type ?Nat and m of type Nat . This function will return the value of n if n is not null and if n is null it will default to the value of m.
  public func nat_opt_to_nat(n : ?Nat, m : Nat) : async Nat {
    switch(n) {
      case(null) {
          return (m);
      };
      case(?val) {
          return val;
      };
    };
  };


  // Challenge 5 : Write a function day_of_the_week that takes a Nat n and returns a Text value corresponding to the day. If n doesn't correspond to any day it will return null .
  // day_of_the_week (1) -> "Monday".
  // day_of_the_week (7) -> "Sunday".
  // day_of_the_week (12) -> null.
  public func day_of_the_week(n : Nat) : async ?Text {
    let dayNames : [Text] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    var result : ?Text = null;

    if (n >= 1 and n <= 7) {
      result := Option.make<Text>(dayNames[n-1]);
    };
    return result;
  };


  // Challenge 6 : Write a function populate_array that takes an array [?Nat] and returns an array [Nat] where all null values have been replaced by 0.
  // Note : Do not use a loop.
  public func populate_array(array : [?Nat]) : async [Nat] {
    func null_to_zero(n : ?Nat) : Nat {
      switch(n) {
        case(null) {
          return 0;
        };
        case(?val) {
          return val;
        };
      };
    };

    return Array.map<?Nat, Nat>(array, null_to_zero);
  };


  // Challenge 7 : Write a function sum_of_array that takes an array [Nat] and returns the sum of a values in the array.
  // Note : Do not use a loop.
  public func sum_of_array(array : [Nat]) : async Nat {
    var sum : Nat = 0;
    ignore Array.filter<Nat>(array, func (n : Nat) : Bool {sum += n; return false});
    return sum;
  };


  // Challenge 8 : Write a function squared_array that takes an array [Nat] and returns a new array where each value has been squared.
  // Note : Do not use a loop.
  public func squared_array(array : [Nat]) : async [Nat] {
    return Array.map<Nat, Nat>(array, func (n : Nat) : Nat {return n * n});
  };


  // Challenge 9 : Write a function increase_by_index that takes an array [Nat] and returns a new array where each number has been increased by it's corresponding index.
  // Note : increase_by_index [1, 4, 8, 0] -> [1 + 0, 4 + 1 , 8 + 2 , 0 + 3] = [1,5,10,3]
  // Note 2 : Do not use a loop.
  public func increase_by_index(array : [Nat]) : async [Nat] {
    return Array.mapEntries<Nat, Nat>(array, func (n : Nat, i : Nat) : Nat {return n + i});
  };


  // Challenge 10 : Write a higher order function contains<A> that takes 3 parameters : an array [A] , a of type A and a function f that takes a tuple of type (A,A) and returns a boolean.
  // This function should return a boolean indicating whether or not a is present in the array.
  // The function f returns true if and only if its two arguments are equal.

//  public func contains<A>(array : [A], a : A, f : (A, A) -> Bool) : async Bool {
//    for (i : A in array.vals()) {
//      if (f(i, a)) {
//        return true;
//      };
//    };
//    return false;
//  };
// the above fails with "type error [M0031], shared function has non-shared parameter type"

// this, though, giving f a "shared" argument and async return value, compiles with no error:
  public func test(f : shared (Nat, Nat) -> async Bool) : async Bool {
    return await f(1, 1);
  };

// but if I try to do something similar with contains<A>, like the following,
// it gives the same error:
//  public func contains<A>(array : [A], a : A, f : shared (A, A) -> async Bool) : async Bool {
//    for (i : A in array.vals()) {
//      if (await f(i, a)) {
//        return true;
//      };
//    };
//    return false;
//  };

}