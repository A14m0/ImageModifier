with Interfaces; use Interfaces;

package BMP is
    -- define our types and file package
    subtype Byte is Unsigned_8;
    type Bytes_Array is array(Unsigned_32 range <>) of Byte;
    subtype BMP_Index is Unsigned_32 range 1..26;
    
    procedure Parse_Header (
                B : in Bytes_Array;
                F : out Unsigned_32;
                O : out Unsigned_32;
                W : out Unsigned_32;
                H : out Unsigned_32);

private
    procedure Convert_Bytes_To_U32(
                B : in Bytes_Array;
                O : out Unsigned_32
    ) with Pre => (B'Last-B'First = 4);
end BMP;