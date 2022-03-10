module {
  public type Animal = {
    species : Text;
    energy : Nat;
  };

  // Challenge 3 : In animal.mo create a public function called animal_sleep that takes an
  // Animal and returns the same Animal where the field energy has been increased by 10.
  public func animal_sleep (input: Animal) : Animal {
    var output : Animal = {
      species = input.species;
      energy = input.energy + 10;
    };
    return output;
  }
};