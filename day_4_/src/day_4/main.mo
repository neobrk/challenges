import Book "custom";
import Animal "animal";
import List "mo:base/List";

actor {
  // Challenge 1 : Create two files called custom.mo and main.mo, create your own type inside
  // custon.mo and import it in your main.mo file. In main, create a public function fun that
  // takes no argument but return a value of your custom type.
  public type Book = Book.Book;

  public func fun () : async Book {

    let book : Book = {
      title = "Piranesi";
      author = "Susanna Clarke";
      publication_year = 2020;
      pages = 272;
    };
    return book;
  };


  // Challenge 2 : Create a new file called animal.mo with at least 2 property (specie of type
  // Text, energy of type Nat), import this type in your main.mo and create a variable that
  // will store an animal.
  public type Animal = Animal.Animal;

  var animal : Animal = {
    species = "Cat";
    energy = 0;
  };


  // Challenge 4 : In main.mo create a public function called create_animal_then_takes_a_break
  // that takes two parameter : a specie of type Text, an number of energy point of type Nat
  // and returns an animal. This function will create a new animal based on the parameters
  // passed and then put this animal to sleep before returning it !
  public func create_animal_then_takes_a_break (species : Text, energy : Nat) : async Animal {
    var animal : Animal = {
      species = species;
      energy = energy;
    };

    return Animal.animal_sleep(animal);
  };


  // Challenge 5 : In main.mo, import the type List from the base Library and create a list
  // that stores animal.
  var animalList : List.List<Animal> = null;


  // Challenge 6 : In main.mo : create a function called push_animal that takes an animal as
  // parameter and returns nothing this function should add this animal to your list created
  // in challenge 5. Then create a second functionc called get_animals that takes no parameter
  // but returns an Array that contains all animals stored in the list.
  public func push_animal (animal : Animal) : async () {
    animalList := List.push(animal, animalList);
  };

  public func get_animals () : async [Animal] {
    return List.toArray<Animal>(animalList);
  };
};
