import Result "mo:base/Result";

actor {
  // Challenge 8 : Create another canister and use to mint a NFT by calling the mint method
  // of your first canister.
  type Result = Result.Result<(), Text>;

  let day_6 : actor { mint : () -> async Result} = actor("qoctq-giaaa-aaaaa-aaaea-cai");

  public func callMinter() : async Text {
    let result : Result = await day_6.mint();
    switch (result) {
      case (#ok) {
        return "Okay";
      };
      case (#err(msg)) {
        return msg;
      };
    };
  };
};
