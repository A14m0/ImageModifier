with Interfaces; use Interfaces;

package BMP is
    -- define our types and file package
    subtype Byte is Unsigned_8;
    type Bytes_Array is array(Natural range <>) of Byte;
    subtype BMP_Index is Natural range 1..14;
    
    procedure ParseHeader(
                B : in Bytes_Array;
                F : out Unsigned_32;
                O : out Unsigned_32);

private
    procedure ConvertBytesToU32(
                B : in Bytes_Array;
                O : out Unsigned_32
    ) with Pre => (B'Last-B'First = 4);
end BMP;