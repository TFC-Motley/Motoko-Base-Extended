import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import NatStruct "mo:struct/Primitives/Nat";
import Hashmap "mo:hashmap/Map";
import Hashset "mo:hashmap/Set";

module {

  public let Base = Nat;

  public let Struct = NatStruct;

  public type Set = Hashset.Set<Nat>;

  public type Map<T> = Hashmap.Map<Nat,T>;
  
  public let { nhash } = Hashmap;

  public module Map = {

    public func init<T>() : Map<T> { Hashmap.new<Nat,T>(nhash) };

    public func has<T>( map : Map<T>, k : Nat ) : Bool { Hashmap.has(map, nhash, k) };
  
    public func get<T>( map : Map<T>, k : Nat ) : ?T { Hashmap.get(map, nhash, k) };

    public func set<T>( map : Map<T>, k : Nat, v : T ) : () { Hashmap.set(map, nhash, k, v) };

    public func put<T>( map : Map<T>, k : Nat, v : T ) : ?T { Hashmap.put(map, nhash, k, v) };

    public func delete<T>( map : Map<T>, k : Nat ) : () { Hashmap.delete(map, nhash, k) };

    public func remove<T>( map : Map<T>, k : Nat ) : ?T { Hashmap.remove(map, nhash, k) };

    public func entries<T>( map : Map<T> ) : Iter.Iter<(Nat,T)> { Hashmap.entries<Nat,T>(map) };

    public func keys<T>( map : Map<T> ) : Iter.Iter<Nat> { Hashmap.keys<Nat,T>(map) };

    public func vals<T>( map : Map<T> ) : Iter.Iter<T> { Hashmap.vals<Nat,T>(map) };

    public func size<T>( map : Map<T> ) : Nat { Hashmap.size(map) };

  };

  public module Set = {

    public func init() : Set { Hashset.new<Nat>(nhash) };

    public func match( set : Set, k : Nat ) : Bool { Hashset.has(set, nhash, k) };

    public func insert( set : Set, k : Nat) : () { Hashset.add(set, nhash, k) };

    public func delete( set : Set, k : Nat ) : () { Hashset.delete(set, nhash, k) };

    public func fromIter( iter : Iter.Iter<Nat> ) : Set { Hashset.fromIter(iter, nhash) };

    public func toArray( set : Set ) : [Nat] { Hashset.toArray<Nat>( set ) };

    public func keys( set : Set ) : Iter.Iter<Nat> { Hashset.keys(set) };

    public func size( set : Set ) : Nat { Hashset.size(set) };

  };

}