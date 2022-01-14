with Ada.Text_IO; use Ada.Text_IO;
with Ada.Direct_IO; 
with BMP; use BMP;
with Interfaces; use Interfaces;

procedure Main is
    -- type definitions
    package Byte_IO is
        new Ada.Direct_IO(Byte);
    use Byte_IO;


    -- lets declare variables
    -- File-related variables
    Input_File : Byte_IO.File_Type;
    Output_File : Byte_IO.File_Type;
    Input_FName : constant String := "color-blind-test.bmp";
    Output_FName : constant String := "not-so-colorblind.bmp";
    -- BMP data
    Header : Bytes_Array(BMP_Index);
    Filesize : Unsigned_32;
    Offset : Unsigned_32;

begin
    Put_Line("[+] Opening file '"
             & Input_FName
             & "'...");

    -- try to open the file
    Open(Input_File, In_File, Input_FName);

    -- now we read the bytes
    declare
        tmp : Byte;
    begin
        for I in BMP_Index loop
            Read(Input_File, tmp);
            Header(I) := tmp;
            Put_Line(Byte'Image(tmp));
        end loop;
    end;

    -- now that we have populated the header, 
    -- lets get what we need from it
    ParseHeader(Header, Filesize, Offset);


end Main;