with Ada.Text_IO; use Ada.Text_IO;

package body BMP is
    procedure Parse_Header 
        (B : in Bytes_Array;
         F : out Unsigned_32;
         O : out Unsigned_32;
         W : out Unsigned_32;
         H : out Unsigned_32)
    is
        -- declare the ranges for the 
        -- filesize integer and the
        -- pixel array offset integer
        subtype Filesize_Index is BMP_Index range 3..6;
        subtype PixOffset_Index is BMP_Index range 16#A#..16#D#;
        subtype Width_Index is BMP_Index range 16#F#..16#12#;
        subtype Height_Index is BMP_Index range 16#13#..16#16#;
    begin
        -- Convert the values 
        Convert_Bytes_To_U32(
            B(Filesize_Index), 
            F);
        Convert_Bytes_To_U32 (
            B(PixOffset_Index), 
            O);
        Convert_Bytes_To_U32 (
            B(Width_Index), 
            W);
        Convert_Bytes_To_U32 (
            B(Height_Index), 
            H);

    end Parse_Header;


    -- Converts 4 bytes to a single U32
    -- Note that the 4 bytes length is 
    -- enforced in `bmp.ads` through the 
    -- included precondition
    procedure Convert_Bytes_To_U32
        (B : in Bytes_Array;
         O : out Unsigned_32) 
    is
        tmp : Unsigned_32 := 0;
        ctr : Integer := 3;
    begin
        for I in reverse B'Range loop
            Put(B(I)'Image & " ");
            tmp := tmp + shift_left(
                            Unsigned_32(B(I)), 
                            8*ctr);
            ctr := ctr - 1;
            
        end loop;
        New_Line;

        O := tmp;
    end Convert_Bytes_To_U32;
end BMP;