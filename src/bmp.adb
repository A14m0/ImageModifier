with Ada.Text_IO; use Ada.Text_IO;

package body BMP is
    procedure ParseHeader 
        (B : in Bytes_Array;
         F : out Unsigned_32;
         O : out Unsigned_32)
    is
        -- declare the ranges for the 
        -- filesize integer and the
        -- pixel array offset integer
        subtype Filesize_Index is BMP_Index range 3..6;
        subtype PixOffset_Index is BMP_Index range 16#A#..16#D#;
    begin
        -- 
        Put_Line("Filesize_Index: "
                 & Filesize_Index'Image(Filesize_Index'First)
                 & " - "
                 & Filesize_Index'Image(Filesize_Index'Last));
        Put_Line("PixOffset_Index: "
                 & PixOffset_Index'Image(PixOffset_Index'First)
                 & " - "
                 & PixOffset_Index'Image(PixOffset_Index'Last));
        
        ConvertBytesToU32(
            B(Filesize_Index), 
            O);

        Put_Line("Converted value: "
                 & O'Image);

    end ParseHeader;


    -- Converts 4 bytes to a single U32
    -- Note that the 4 bytes length is 
    -- enforced in `bmp.ads` through the 
    -- included precondition
    procedure ConvertBytesToU32
        (B : in Bytes_Array;
         O : out Unsigned_32) 
    is
        tmp : Unsigned_32 := 0;
        ctr : Integer := 3;
    begin
        for I in reverse B'Range loop
            tmp := tmp + shift_left(
                            Unsigned_32(B(I)), 
                            Integer(8*ctr));
            ctr := ctr - 1;
        end loop;

        O := tmp;
    end ConvertBytesToU32;
end BMP;