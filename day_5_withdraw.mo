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

actor day_5_withdraw {
  // Challenge 7 (hard ⚠️) : Write a function withdraw_cycles that takes a parameter n of type
  // Nat corresponding to the number of cycles you want to withdraw from the canister and send
  // it to caller asumming the caller has a callback called deposit_cycles()
  // Note : You need two canisters.
  // Note 2 : Don't do that in production without admin protection or your might be the target
  // of a cycle draining attack.

   public func withdraw_cycles(n : Nat, callback : shared () -> async (Nat) ) : () {
    Cycles.add(n);
    ignore callback();
  };

};