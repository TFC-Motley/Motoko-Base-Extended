import Prim "mo:⛔";
import Blob "mo:base/Blob";
import BlobStruct "mo:struct/Primitives/Blob";

module {

  public let Base = Blob;

  public let Struct = BlobStruct;

  public func range( x : Blob, r : (Nat,Nat) ) : Blob {
    assert x.size() > r.1;
    let buff = Prim.Array_init<Nat8>(r.1-(r.0)+1, 0);
    let bytes : [Nat8] = Base.toArray(x);
    var i_index : Nat = r.0;
    var o_index : Nat = 0;  
    label l loop {
      if ( i_index > r.1 ) break l;
      buff[o_index] := bytes[i_index];
      i_index += 1;
      o_index += 1;
    };
    Base.fromArrayMut( buff );
  };  

}