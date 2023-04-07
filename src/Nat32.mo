import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import RBT "mo:stableRBT/StableRBTree";
import Nat32Struct "mo:struct/Primitives/Nat32";
import Hashmap "mo:hashmap/Map";
import Hashset "mo:hashmap/Set";

module {

  public type Tree<T> = RBT.Tree<Nat32,T>;

  public let Base = Nat32;

  public let Struct = Nat32Struct;

  public type Set = Hashset.Set<Nat32>;

  public type Map<T> = Hashmap.Map<Nat32,T>;
  
  public let { n32hash } = Hashmap;


  public module Set = {

    public func init() : Set { Hashset.new<Nat32>(n32hash) };

    public func match( set : Set, k : Nat32 ) : Bool { Hashset.has(set, n32hash, k) };

    public func insert( set : Set, k : Nat32) : () { Hashset.add(set, n32hash, k) };

    public func put( set : Set, k : Nat32 ) : Bool { Hashset.put(set, n32hash, k) };

    public func delete( set : Set, k : Nat32 ) : () { Hashset.delete(set, n32hash, k) };

    public func fromIter( iter : Iter.Iter<Nat32> ) : Set { Hashset.fromIter(iter, n32hash) };

    public func toArray( set : Set ) : [Nat32] { Hashset.toArray<Nat32>( set ) };

    public func keys( set : Set ) : Iter.Iter<Nat32> { Hashset.keys(set) };

    public func size( set : Set ) : Nat { Hashset.size(set) };

  };


  public module Map = {

    public func init<T>() : Map<T> { Hashmap.new<Nat32,T>(n32hash) };

    public func has<T>( map : Map<T>, k : Nat32 ) : Bool { Hashmap.has(map, n32hash, k) };
  
    public func get<T>( map : Map<T>, k : Nat32 ) : ?T { Hashmap.get(map, n32hash, k) };

    public func set<T>( map : Map<T>, k : Nat32, v : T ) : () { Hashmap.set(map, n32hash, k, v) };

    public func put<T>( map : Map<T>, k : Nat32, v : T ) : ?T { Hashmap.put(map, n32hash, k, v) };

    public func delete<T>( map : Map<T>, k : Nat32 ) : () { Hashmap.delete(map, n32hash, k) };

    public func remove<T>( map : Map<T>, k : Nat32 ) : ?T { Hashmap.remove(map, n32hash, k) };

    public func entries<T>( map : Map<T> ) : Iter.Iter<(Nat32,T)> { Hashmap.entries<Nat32,T>(map) };

    public func keys<T>( map : Map<T> ) : Iter.Iter<Nat32> { Hashmap.keys<Nat32,T>(map) };

    public func vals<T>( map : Map<T> ) : Iter.Iter<T> { Hashmap.vals<Nat32,T>(map) };

    public func size<T>( map : Map<T> ) : Nat { Hashmap.size(map) };

  };


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