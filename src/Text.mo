import Prim "mo:⛔";
import SB "mo:stableBuffer/StableBuffer";
import RBT "mo:stableRBT/StableRBTree";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Stack "mo:base/Stack";
import Text "mo:base/Text";
import Option "mo:base/Option";
import TrieSet "mo:base/TrieSet";
import Hashmap "mo:hashmap/Map";

module {

  type Hash = Nat32;

  public type Text = Prim.Types.Text;

  public type Pattern = Text.Pattern;
  public type Tree<T> = RBT.Tree<Text,T>;
  public type Buffer = SB.StableBuffer<Text>;
  public type Set = TrieSet.Set<Text>;
  public type LargeSet = RBT.Tree<Text,()>;

  public let Base = Text;

  public type Map<T> = Hashmap.Map<Text,T>;
  
  public let { thash } = Hashmap;

  public module Map = {

    public func init<T>() : Map<T> { Hashmap.new<Text,T>(thash) };

    public func has<T>( map : Map<T>, k : Text ) : Bool { Hashmap.has(map, thash, k) };
  
    public func get<T>( map : Map<T>, k : Text ) : ?T { Hashmap.get(map, thash, k) };

    public func set<T>( map : Map<T>, k : Text, v : T ) : () { Hashmap.set(map, thash, k, v) };

    public func put<T>( map : Map<T>, k : Text, v : T ) : ?T { Hashmap.put(map, thash, k, v) };

    public func delete<T>( map : Map<T>, k : Text ) : () { Hashmap.delete(map, thash, k) };

    public func remove<T>( map : Map<T>, k : Text ) : ?T { Hashmap.remove(map, thash, k) };

    public func entries<T>( map : Map<T> ) : Iter.Iter<(Text,T)> { Hashmap.entries<Text,T>(map) };
  
    public func fromIter<T>( iter : { next: () -> ?(Text,T) } ) : Map<T> { Hashmap.fromIter<Text,T>(iter, thash) };

    public func find<T>( map : Map<T>, fn: (Text, T) -> Bool ) : ?(Text, T) { Hashmap.find<Text,T>(map, fn) }; 

    public func keys<T>( map : Map<T> ) : Iter.Iter<Text> { Hashmap.keys<Text,T>(map) };

    public func vals<T>( map : Map<T> ) : Iter.Iter<T> { Hashmap.vals<Text,T>(map) };

    public func size<T>( map : Map<T> ) : Nat { Hashmap.size(map) };

  };

  public module Set = {

    public func init() : Set { TrieSet.empty<Text>() };

    public func insert( s : Set, p : Text ) : Set { 
      TrieSet.put<Text>(s, p, Base.hash(p), Text.equal);
    };
    public func delete(s : Set, p : Text) : Set {
      TrieSet.delete<Text>( s, p, Base.hash(p), Text.equal);
    };
    public func equal(s1 : Set, s2 : Set) : Bool {
      TrieSet.equal<Text>(s1, s2, Text.equal);
    };
    public func size(s : Set) : Nat {
      TrieSet.size<Text>(s);
    };
    public func match(s : Set, p : Text) : Bool {
      TrieSet.mem<Text>(s, p, Base.hash(p), Text.equal);
    };
    public func union(s1 : Set, s2 : Set) : Set {
      TrieSet.union<Text>(s1, s2, Text.equal);
    };
    public func diff(s1 : Set, s2 : Set) : Set {
      TrieSet.diff<Text>(s1, s2, Text.equal);
    };
    public func intersect(s1 : Set, s2 : Set) : Set {
      TrieSet.intersect<Text>(s1, s2, Text.equal);
    };
    public func fromArray(arr : [Text]) : Set {
      TrieSet.fromArray<Text>(arr, Base.hash, Text.equal);
    };
    public func toArray(s : Set) : [Text] {
      TrieSet.toArray<Text>(s);
    };

  };

  public module Tree = {

    public func init<T>() : Tree<T> { RBT.init<Text,T>() };

    public func scan<T>( tree : Tree<T>, lower : Text, upper : Text ) : [(Text,T)] {
      RBT.scanLimit<Text,T>(tree, Text.compare, lower, upper, #fwd, 10000).results;
    };
    public func keys<T>( tree : Tree<T> ) : Iter.Iter<Text> {
      Iter.map<(Text,T),Text>(entries(tree), func (kv : (Text, T)) : Text { kv.0 });
    };
    public func vals<T>( tree : Tree<T> ) : Iter.Iter<T> {
      Iter.map<(Text,T),T>(entries(tree), func (kv : (Text, T)) : T { kv.1 });
    };
    public func fromEntries<T>( arr : [(Text,T)] ) : Tree<T> {
      var tree : Tree<T> = init<T>();
      for ( e in arr.vals() ){
        tree := insert<T>(tree, e.0, e.1);
      };
      tree;
    };
    public func entries<T>( tree : Tree<T> ) : Iter.Iter<(Text, T)> {
      RBT.entries<Text,T>(tree);
    };
    public func insert<T>( tree : Tree<T>, key : Text, val : T ) : Tree<T> {
      RBT.put<Text,T>(tree, Text.compare, key, val);
    };
    public func delete<T>( tree : Tree<T>, key : Text ) : Tree<T> {
      RBT.delete<Text, T>(tree, Text.compare, key );
    };
    public func find<T>( tree : Tree<T>, key : Text) : ?T {
      RBT.get<Text,T>(tree, Text.compare, key);
    };
    public func size<T>( tree : Tree<T>) : Nat {
      RBT.size<Text,T>(tree);
    };

  };

  public module Buffer = {

    public func initPresized(initCapacity: Nat): Buffer {
      SB.initPresized<Text>(initCapacity);
    };
    public func init(): Buffer {
      SB.init<Text>();
    };
    public func add(buffer: Buffer, elem: Text): () {
      SB.add<Text>(buffer, elem);
    };
    public func removeLast(buffer: Buffer) : ?Text {
      SB.removeLast<Text>(buffer);
    };
    public func append( b1: Buffer, b2 : Buffer): () {
      SB.append<Text>(b1,b2);
    };
    public func size(buffer: Buffer) : Nat {
      buffer.count;
    };
    public func clear(buffer: Buffer): () {
      buffer.count := 0;
    };
    public func clone(buffer: Buffer) : Buffer {
      SB.clone<Text>(buffer);
    };
    public func vals(buffer: Buffer) : Iter.Iter<Text> {
      SB.vals<Text>(buffer);
    };
    public func fromArray( arr: [Text]): Buffer {
      SB.fromArray<Text>(arr);
    };
    public func toArray(buffer: Buffer) : [Text] {
      SB.toArray<Text>(buffer);
    };
    public func toVarArray(buffer: Buffer) : [var Text] {
      SB.toVarArray<Text>(buffer);
    };
    public func get(buffer: Buffer, i : Nat) : Text {
      SB.get<Text>(buffer, i);
    };
    public func getOpt(buffer: Buffer, i : Nat) : ?Text {
      SB.getOpt<Text>(buffer, i);
    };
    public func put(buffer: Buffer, i : Nat, elem : Text) {
      SB.put<Text>(buffer, i, elem);
    };    

  };

};