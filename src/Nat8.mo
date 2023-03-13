import Nat8 "mo:base/Nat8";
import Iter "mo:base/Iter";
import RBT "mo:stableRBT/StableRBTree";
import Nat8Struct "mo:struct/Primitives/Nat8";

module {

  public let Base = Nat8;

  public let Struct = Nat8Struct;

  type Tree<T> = RBT.Tree<Nat8,T>;

  public module Tree = {

    public func init<T>() : Tree<T> { RBT.init<Nat8,T>() };

    public func scan<T>( tree : Tree<T>, lower : Nat8, upper : Nat8 ) : [(Nat8,T)] {
      RBT.scanLimit<Nat8,T>(tree, Nat8.compare, lower, upper, #fwd, 10000).results;
    };
    public func keys<T>( tree : Tree<T> ) : Iter.Iter<Nat8> {
      Iter.map<(Nat8,T),Nat8>(entries(tree), func (kv : (Nat8, T)) : Nat8 { kv.0 });
    };
    public func vals<T>( tree : Tree<T> ) : Iter.Iter<T> {
      Iter.map<(Nat8,T),T>(entries(tree), func (kv : (Nat8, T)) : T { kv.1 });
    };
    public func fromEntries<T>( arr : [(Nat8,T)] ) : Tree<T> {
      var tree : Tree<T> = init<T>();
      for ( e in arr.vals() ){
        tree := insert<T>(tree, e.0, e.1);
      };
      tree;
    };
    public func entries<T>( tree : Tree<T> ) : Iter.Iter<(Nat8, T)> {
      RBT.entries<Nat8,T>(tree);
    };
    public func insert<T>( tree : Tree<T>, key : Nat8, val : T ) : Tree<T> {
      RBT.put<Nat8,T>(tree, Nat8.compare, key, val);
    };
    public func delete<T>( tree : Tree<T>, key : Nat8 ) : Tree<T> {
      RBT.delete<Nat8, T>(tree, Nat8.compare, key );
    };
    public func find<T>( tree : Tree<T>, key : Nat8) : ?T {
      RBT.get<Nat8,T>(tree, Nat8.compare, key);
    };
    public func size<T>( tree : Tree<T>) : Nat {
      RBT.size<Nat8,T>(tree);
    };

  };

}