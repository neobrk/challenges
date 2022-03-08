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
  // Challenge 1: Write a function nat_to_nat8 that converts a Nat n to a Nat8. Make sure that your function never trap.
  public func nat_to_nat8(n : Nat) : async ?Nat8 {
    if (n >= 0 and n <= 255) {
      return Option.make(Nat8.fromNat(n));
    } else {
      return null;
    }
  };


  // Challenge 2: Write a function max_number_with_n_bits that takes a Nat n and returns the maximum number than can be represented with only n-bits.
  public func max_number_with_n_bits(n : Nat) : async Nat {
    return 2 ** n - 1;
  };


  // Challenge 3: Write a function decimal_to_bits that takes a Nat n and returns a Text corresponding to the binary representation of this number.
  // Note: decimal_to_bits(255) -> "11111111".
  public func decimal_to_bits(n : Nat): async Text {
    return _decimal_to_bits(n);
  };
    
  func _decimal_to_bits(n : Nat) : Text {
    if (n == 0) {
      return "0";
    } else if (n == 1) {
      return "1";
    } else {
      return _decimal_to_bits(n / 2) # _decimal_to_bits(n % 2);
    };
  };


  // Challenge 4: Write a function capitalize_character that takes a Char c and returns the capitalized version of it.
  public func capitalize_character(c : Char): async Char {
    return _capitalize_character(c);
  };

  func _capitalize_character(c : Char): Char {
    if (Char.isLowercase(c)) {
     return Char.fromNat32(Char.toNat32(c) + Char.toNat32('A') - Char.toNat32('a'));
    } else {
      return c;
    };
  };


  // Challenge 5: Write a function capitalize_text that takes a Text t and returns the capitalized version of it.
  public func capitalize_text(t : Text): async Text {
    var result : Text = "";
    for (c : Char in t.chars()) {
      result #= Char.toText(_capitalize_character(c));
    };
    return result;
  };


  // Challenge 6: Write a function is_inside that takes two arguments : a Text t and a Char c and returns a Bool indicating if c is inside t .
  public func is_inside(t : Text, c : Char): async Bool {
    for (i : Char in t.chars()) {
      if (i == c) return true;
    };
    return false;
  };
  

  // Challenge 7: Write a function trim_whitespace that takes a text t and returns the trimmed version of t. Note : Trim means removing any leading and trailing spaces from the text : trim_whitespace(" Hello ") -> "Hello".
  public func trim_whitespace(t : Text): async Text {
    var charBuf : Buffer.Buffer<Char> = Buffer.Buffer<Char>(t.size());

    for (c in t.chars()) {
      charBuf.add(c);
    };
    var chars : [Char] = charBuf.toArray();

    var start : Nat = 0;
    label findStart while (start < chars.size()) {
      if (chars[start] == ' ') {
        start += 1;
      } else {
        break findStart;
      };
    };

    var end : Nat = chars.size();
    label findEnd while (end > 0) {
      if (chars[end-1] == ' ') {
        end -= 1;
      } else {
        break findEnd;
      };
    };

    var result : Text = "";
    while (end > start) {
      result #= Char.toText(chars[start]);
      start += 1;
    };

    return result;
  };
  

  // Challenge 8: Write a function duplicated_character that takes a Text t and returns the first duplicated character in t converted to Text. Note : The function should return the whole Text if there is no duplicate character : duplicated_character("Hello") -> "l" & duplicated_character("World") -> "World".
  public func duplicated_character(t : Text): async Text {
    var charBuf : Buffer.Buffer<Char> = Buffer.Buffer<Char>(t.size());

    var charNum : Nat = 0;
    var prevChar : Char = ' ';
    for (c in t.chars()) {
      if (charNum > 0 and c == prevChar) {
        return Char.toText(c);
      };
      prevChar := c;
      charNum += 1;
    };

    return t;
  };


  // Challenge 9: Write a function size_in_bytes that takes Text t and returns the number of bytes this text takes when encoded as UTF-8.
  public func size_in_bytes(t : Text): async Nat {
    return Text.encodeUtf8(t).size();
  };

  // Challenge 10: Implement a function bubble_sort that takes an array of natural numbers and returns the sorted array .
  public func bubble_sort(array : [Nat]) : async [Nat] {
    let N : Nat = array.size();
    if (N == 0) return array;

    let result : [var Nat] = Array.thaw(array);

    var i : Nat = 1;
    while (i < N) {
      var j : Nat = 0;
      while (j < N-i) {
        if (result[j] > result[j+1]) {
          let temp : Nat = result[j];
          result[j] := result[j+1];
          result[j+1] := temp;
        };
        j += 1;
      };
      i += 1;
    };
    return Array.freeze(result);
  };

};
