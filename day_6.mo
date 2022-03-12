import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import HTTP "http";

actor {
  // Challenge 1 : Create an actor in main.mo and declare the following types.
  // TokenIndex of type Nat.
  // Error which is a variant type with multiples tags :
  public type TokenIndex = Nat;
  public type Error = {
    #undefined;
    #burned;
  };


  // Challenge 2 : Declare an HashMap called registry with Key of type TokenIndex and value
  // of type Principal. This will keeep track of which principal owns which TokenIndex.
  func hashTokenIndex(i : TokenIndex) : Hash.Hash {
    return Text.hash(Nat.toText(i));
  };

  // Challenge 7 : Modify the actor so that you can safely upgrade it without loosing any
  // state.
  stable var registryEntries : [(TokenIndex, Principal)] = [];
  //let registry = HashMap.HashMap<TokenIndex, Principal>(0, Nat.equal, hashTokenIndex);
  let registry = HashMap.fromIter<TokenIndex, Principal>(registryEntries.vals(), 1,
                                                         Nat.equal, hashTokenIndex);


  // Challenge 3 : Declare a variable of type Nat called nextTokenIndex, initialized at 0
  // that will keep track of the number of minted NFTs.
  // Write a function called mint that takes no argument.
  // This function should :
  // Returns a result of type Result and indicate an error in case the caller is anonymous.
  // If the user is authenticated : associate the current TokenIndex with the caller (use
  // the HashMap we've created) and increase nextTokenIndex.
  //var nextTokenIndex : Nat = 0;
  //var nextTokenIndex : TokenIndex = 0;
  stable var nextTokenIndex : TokenIndex = 0;

  type Result = Result.Result<(), Text>;
  public shared ({caller}) func mint() : async Result {
    if(Principal.isAnonymous(caller)){
      return #err("You need to be authenticated to mint");
    } else {
      registry.put(nextTokenIndex, caller);
      nextTokenIndex += 1;
      return #ok;
    };
  };


  // Challenge 4 : Write a function called transfer that takes two arguments :
  // to of type Principal.
  // tokenIndex of type Nat.
  // This function will transfer ownership of tokenIndex to the specified principal. You will
  // check for eventuals errors and returns a result of type Result.
  public shared ({caller}) func transfer(to : Principal, tokenIndex : TokenIndex) : async Result {
    if(Principal.isAnonymous(caller)){
      return #err("You need to be authenticated to transfer");
    };
    if(Principal.isAnonymous(to)){
      return #err("You may not transfer a token to the anonymous Principal");
    };
    let currentOwner : ?Principal = registry.get(tokenIndex);
    switch (currentOwner) {
      case(null) {
        return #err("token #" # Nat.toText(tokenIndex) #
                    " has not been minted and cannot be transfered");
      };
      case (?owner) {
        if (not Principal.equal(owner, caller)) {
          return #err("You do not own token #" # Nat.toText(tokenIndex) #
                      " and cannot transfer it");
        };
      };
    };
    if (Principal.equal(caller, to)) {
      return #err("You already own that token and cannot transfer it to yourself");
    };
    registry.put(tokenIndex, to);
    return #ok;
  };


  // Challenge 5 : Write a function called balance that takes no arguments but returns a list
  // of tokenIndex owned by the called.
  type TokenList = List.List<TokenIndex>;
  public shared ({caller}) func balance() : async TokenList {
    if(Principal.isAnonymous(caller)){
      return null;
    };

    var myTokens : TokenList = null;
    for (i in Iter.range(0, nextTokenIndex - 1)) {
      let iOwner : ?Principal = registry.get(i);
      switch(iOwner) {
        case (null) {
          // ignore
        };
        case (?owner) {
          if (Principal.equal(owner, caller)) {
            myTokens := List.push<TokenIndex>(i, myTokens);
          };
        };
      };
    };
    return myTokens;
  };


  // Challenge 6 : Write a function called http_request that should return a message
  // indicating the number of nft minted so far and the principal of the latest minter. (Use
  // the section on http request in the daily guide).
  public query func http_request(request : HTTP.Request) : async HTTP.Response {
    var message : Text = "";

    message #= "<p>NFTs minted: " # Nat.toText(nextTokenIndex) # "</p>";

    if (nextTokenIndex > 0) {
      let lastMinter : ?Principal = registry.get(nextTokenIndex - 1);
      switch(lastMinter) {
        case (null) {
          // ignore
        };
        case (?owner) {
          message #= "<p>The last NFT was minted by: " # Principal.toText(owner) # "</p>";
        };
      };
    };

    let response = {
      body = Text.encodeUtf8(message);
      headers = [("Content-Type", "text/html; charset=UTF-8")];
      status_code = 200 : Nat16;
      streaming_strategy = null
    };
    return(response);
  };


  // Challenge 7 : Modify the actor so that you can safely upgrade it without loosing any
  // state.
  system func preupgrade() {
    registryEntries := Iter.toArray(registry.entries());
  };

  system func postupgrade() {
    registryEntries := [];
  };
  
  public func somethingNew () {
    Debug.print("upgraded to include something new");
  };
};
