import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import SB "mo:stableBuffer/StableBuffer";
import RBT "mo:stableRBT/StableRBTree";
import TrieSet "mo:base/TrieSet";
import Principal "mo:base/Principal";
import Hashmap "mo:hashmap/Map";


module {

  public type Principal = Principal.Principal;
  public type Tree<T> = RBT.Tree<Principal,T>;
  public type Map<T> = Hashmap.Map<Principal,T>;
  public type Buffer = SB.StableBuffer<Principal>;
  public type Set = TrieSet.Set<Principal>;

  /// Base functions - Copied directly from the Motoko-base repository
  public let Base = Principal;
  
  public func placeholder() : Principal { Base.fromText("aaaaa-aa") };

  public let { phash } = Hashmap;

  public module Map = {

    public func init<T>() : Map<T> { Hashmap.new<Principal,T>(phash) };

    public func has<T>( map : Map<T>, k : Principal ) : Bool { Hashmap.has(map, phash, k) };
  
    public func get<T>( map : Map<T>, k : Principal ) : ?T { Hashmap.get(map, phash, k) };

    public func set<T>( map : Map<T>, k : Principal, v : T ) : () { Hashmap.set(map, phash, k, v) };

    public func put<T>( map : Map<T>, k : Principal, v : T ) : ?T { Hashmap.put(map, phash, k, v) };

    public func delete<T>( map : Map<T>, k : Principal ) : () { Hashmap.delete(map, phash, k) };

    public func remove<T>( map : Map<T>, k : Principal ) : ?T { Hashmap.remove(map, phash, k) };

    public func entries<T>( map : Map<T> ) : Iter.Iter<(Principal,T)> { Hashmap.entries<Principal,T>(map) };

    public func keys<T>( map : Map<T> ) : Iter.Iter<Principal> { Hashmap.keys<Principal,T>(map) };

    public func vals<T>( map : Map<T> ) : Iter.Iter<T> { Hashmap.vals<Principal,T>(map) };

    public func size<T>( map : Map<T> ) : Nat { Hashmap.size(map) };

  };

  public module Set = {

    public func init() : Set { TrieSet.empty<Principal>() };

    public func insert( s : Set, p : Principal ) : Set { 
      TrieSet.put<Principal>(s, p, Base.hash(p), Principal.equal);
    };
    public func delete(s : Set, p : Principal) : Set {
      TrieSet.delete<Principal>( s, p, Base.hash(p), Principal.equal);
    };
    public func equal(s1 : Set, s2 : Set) : Bool {
      TrieSet.equal<Principal>(s1, s2, Principal.equal);
    };
    public func size(s : Set) : Nat {
      TrieSet.size<Principal>(s);
    };
    public func match(s : Set, p : Principal) : Bool {
      TrieSet.mem<Principal>(s, p, Base.hash(p), Principal.equal);
    };
    public func union(s1 : Set, s2 : Set) : Set {
      TrieSet.union<Principal>(s1, s2, Principal.equal);
    };
    public func diff(s1 : Set, s2 : Set) : Set {
      TrieSet.diff<Principal>(s1, s2, Principal.equal);
    };
    public func intersect(s1 : Set, s2 : Set) : Set {
      TrieSet.intersect<Principal>(s1, s2, Principal.equal);
    };
    public func fromArray(arr : [Principal]) : Set {
      TrieSet.fromArray<Principal>(arr, Base.hash, Principal.equal);
    };
    public func toArray(s : Set) : [Principal] {
      TrieSet.toArray<Principal>(s);
    };

  };

  public module Tree = {

    public func init<T>() : Tree<T> { RBT.init<Principal,T>() };

    public func keys<T>( tree : Tree<T> ) : Iter.Iter<Principal> {
      Iter.map<(Principal,T),Principal>(entries(tree), func (kv : (Principal, T)) : Principal { kv.0 });
    };
    public func vals<T>( tree : Tree<T> ) : Iter.Iter<T> {
      Iter.map<(Principal,T),T>(entries(tree), func (kv : (Principal, T)) : T { kv.1 });
    };
    public func entries<T>( tree : Tree<T> ) : Iter.Iter<(Principal, T)> {
      RBT.entries<Principal,T>(tree);
    };
    public func fromEntries<T>( arr : [(Principal,T)] ) : Tree<T> {
      var tree : Tree<T> = init<T>();
      for ( e in arr.vals() ){
        tree := insert<T>(tree, e.0, e.1);
      };
      tree;
    };
    public func insert<T>( tree : Tree<T>, key : Principal, val : T ) : Tree<T> {
      RBT.put<Principal,T>(tree, Principal.compare, key, val);
    };
    public func delete<T>( tree : Tree<T>, key : Principal ) : Tree<T> {
      RBT.delete<Principal, T>(tree, Principal.compare, key );
    };
    public func find<T>( tree : Tree<T>, key : Principal) : ?T {
      RBT.get<Principal,T>(tree, Principal.compare, key);
    };

  };

  public module Buffer = {

    public func initPresized(initCapacity: Nat): Buffer {
      SB.initPresized<Principal>(initCapacity);
    };
    public func init(): Buffer {
      SB.init<Principal>();
    };
    public func add(buffer: Buffer, elem: Principal): () {
      SB.add<Principal>(buffer, elem);
    };
    public func removeLast(buffer: Buffer) : ?Principal {
      SB.removeLast<Principal>(buffer);
    };
    public func append( b1: Buffer, b2 : Buffer): () {
      SB.append<Principal>(b1,b2);
    };
    public func size(buffer: Buffer) : Nat {
      buffer.count;
    };
    public func clear(buffer: Buffer): () {
      buffer.count := 0;
    };
    public func clone(buffer: Buffer) : Buffer {
      SB.clone<Principal>(buffer);
    };
    public func vals(buffer: Buffer) : Iter.Iter<Principal> {
      SB.vals<Principal>(buffer);
    };
    public func fromArray( arr: [Principal]): Buffer {
      SB.fromArray<Principal>(arr);
    };
    public func toArray(buffer: Buffer) : [Principal] {
      SB.toArray<Principal>(buffer);
    };
    public func toVarArray(buffer: Buffer) : [var Principal] {
      SB.toVarArray<Principal>(buffer);
    };
    public func get(buffer: Buffer, i : Nat) : Principal {
      SB.get<Principal>(buffer, i);
    };
    public func getOpt(buffer: Buffer, i : Nat) : ?Principal {
      SB.getOpt<Principal>(buffer, i);
    };
    public func put(buffer: Buffer, i : Nat, elem : Principal) {
      SB.put<Principal>(buffer, i, elem);
    };    

  };

};