import Array "mo:base/Array";

actor {
  // Challenge 1 : Write a function add that takes two natural numbers n and m and returns the sum.
  public func add(n : Nat, m : Nat) : async Nat {
    return n + m;
  };


  // Challenge 2 : Write a function square that takes a natural number n and returns the area of a square of length n.
  public func square(n : Nat) : async Nat {
    return n * n;
  };


  // Challenge 3 : Write a function days_to_second that takes a number of days n and returns the number of seconds.
  public func days_to_second(n : Nat) : async Nat {
    let seconds_per_day : Nat = 60*60*24;
    return n * seconds_per_day;
  };


  // Challenge 4 : Write two functions increment_counter & clear_counter .
  // increment_counter returns the incremented value of counter by n.
  // clear_counter sets the value of counter to 0.

  var counter : Nat = 0;

  public func increment_counter(n : Nat) : async Nat {
    counter := counter + n;
    return counter;
  };

  public func clear_counter() : async () {
    counter := 0;
  };


  // Challenge 5 : Write a function divide that takes two natural numbers n and m and returns a boolean indicating if
  // n divides m.
  public func divide(n : Nat, m : Nat) : async Bool {
    // n divides m means m % n is 0
    return (m % n == 0);
  };


  // Challenge 6 : Write a function is_even that takes a natural number n and returns a boolean indicating if n is
  // even.
  public func is_even(n : Nat) : async Bool {
    return (n % 2 == 0);
  };


  // Challenge 7 : Write a function sum_of_array that takes an array of natural numbers and returns the sum. This
  // function will returns 0 if the array is empty.
  public func sum_of_array(array : [Nat]) : async Nat {
    var sum : Nat = 0;
    for (value in array.vals()) {
      sum += value;
    };
    return sum;
  };


  // Challenge 8 : Write a function maximum that takes an array of natural numbers and returns the maximum value in
  // the array. This function will returns 0 if the array is empty.
  public func maximum(array : [Nat]) : async Nat {
    var max : Nat = 0;
    for (value in array.vals()) {
      if (value > max) max := value;
    };
    return max;
  };


  // Challenge 9 : Write a function remove_from_array that takes 2 parameters : an array of natural numbers and a
  // natural number n and returns a new array where all occurences of n have been removed (order should remain
  // unchanged).
  public func remove_from_array(array : [Nat], n : Nat) : async [Nat] {
    return Array.filter(array, func(value: Nat) : Bool { value != n });
  };


  // Challenge 10 : Implement a function selection_sort that takes an array of natural numbers and returns the sorted
  // array .
  public func selection_sort(array : [Nat]) : async [Nat] {
    var j : Nat = 0;
    let n : Nat = array.size();
    let result : [var Nat] = Array.thaw(array);

    while (j + 1 < n) {
      var iMin : Nat = j;
      var i : Nat = j + 1;
       while (i < n) {
        if (result[i] < result[iMin]) iMin := i;
        i += 1;
      };
      if (iMin != j) {
        let temp : Nat = result[j];
        result[j] := result[iMin];
        result[iMin] := temp;
      };
      j += 1;
    };
    return Array.freeze(result);
  };

};
