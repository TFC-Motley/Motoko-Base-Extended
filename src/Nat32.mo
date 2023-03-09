import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import RBT "mo:stableRBT/StableRBTree";
import Nat32Struct "mo:struct/Primitives/Nat32";

module {

  public type Tree<T> = RBT.Tree<Nat32,T>;

  public let Base = Nat32;

  public let Struct = Nat32Struct;

  public module Tree = {

    public func init<T>() : Tree<T> { RBT.init<Nat32,T>() };

    public func scan<T>( tree : Tree<T>, lower : Nat32, upper : Nat32 ) : [(Nat32,T)] {
      RBT.scanLimit<Nat32,T>(tree, Nat32.compare, lower, upper, #fwd, 10000).results;
    };
    public func keys<T>( tree : Tree<T> ) : Iter.Iter<Nat32> {
      Iter.map<(Nat32,T),Nat32>(entries(tree), func (kv : (Nat32, T)) : Nat32 { kv.0 });
    };
    public func vals<T>( tree : Tree<T> ) : Iter.Iter<T> {
      Iter.map<(Nat32,T),T>(entries(tree), func (kv : (Nat32, T)) : T { kv.1 });
    };
    public func fromEntries<T>( arr : [(Nat32,T)] ) : Tree<T> {
      var tree : Tree<T> = init<T>();
      for ( e in arr.vals() ){
        tree := insert<T>(tree, e.0, e.1);
      };
      tree;
    };
    public func entries<T>( tree : Tree<T> ) : Iter.Iter<(Nat32, T)> {
      RBT.entries<Nat32,T>(tree);
    };
    public func insert<T>( tree : Tree<T>, key : Nat32, val : T ) : Tree<T> {
      RBT.put<Nat32,T>(tree, Nat32.compare, key, val);
    };
    public func delete<T>( tree : Tree<T>, key : Nat32 ) : Tree<T> {
      RBT.delete<Nat32, T>(tree, Nat32.compare, key );
    };
    public func find<T>( tree : Tree<T>, key : Nat32) : ?T {
      RBT.get<Nat32,T>(tree, Nat32.compare, key);
    };
    public func size<T>( tree : Tree<T>) : Nat {
      RBT.size<Nat32,T>(tree);
    };

  };

}