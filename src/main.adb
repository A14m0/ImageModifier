with Ada.Text_IO; use Ada.Text_IO;
with Ada.Direct_IO; 
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
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
    --Input_FName : constant String := "color-blind-test.bmp";
    Input_FName : Unbounded_String;
    Output_FName : constant String := "not-so-colorblind.bmp";
    -- BMP data
    Header : Bytes_Array(BMP_Index);
    Filesize : Unsigned_32;
    Offset : Unsigned_32;
    Width : Unsigned_32;
    Height : Unsigned_32;
    Data_Size : Unsigned_32;

begin
    if Argument_Count /= 1 then
        Put_Line("[-] Please provide a path to a BMP file");
        Set_Exit_Status (Failure);
        return;
    end if;

    Input_FName := To_Unbounded_String(Argument (1));

    Put_Line("[+] Opening file '"
             & To_String(Input_FName)
             & "'...");

    -- try to open the file
    Open(Input_File, In_File, To_String(Input_FName));

    -- now we read the bytes
    declare
        tmp : Byte;
    begin
        for I in BMP_Index loop
            Read(Input_File, tmp);
            Header(I) := tmp;
        end loop;
    end;
    New_Line;

    -- now that we have populated the header, 
    -- lets get what we need from it
    Parse_Header(Header, Filesize, Offset,
                 Width, Height);

    Put_Line ("Width: " & Width'Image);
    Put_Line("Height: " & Height'Image);

    -- 4 bytes per pixel, and there are
    -- Width*Height pixels
    Data_Size := (Width*Height); 
    Put_Line ("Data size: "
              & Data_Size'Image);       

    -- now we try and get the data
    declare 
        Data : Bytes_Array(Offset-1..Data_Size);
        Final_Bytes : Bytes_Array(Data_Size..Filesize);
    begin
        Set_Index (Input_File, Byte_IO.Count(Data'First));
        for I in Data'Range loop
            Read(Input_File, Data(I));
        end loop;

        -- now that we have the data, invert it
        for I in Data'Range loop
            if (I - Data'First) mod 4 /= 3 then
                Data(I) := 255 - Data(I);
            end if;
        end loop;

        -- write the data to the output file
        Create(Output_File, Out_File, Output_FName);
        for I in Header'Range loop
            Write(Output_File, Header(I));
        end loop;

        declare 
            tmp : Byte;
        begin
            Set_Index(Input_File, Byte_IO.Count(BMP_Index'Last+1));
            for I in BMP_Index'Last..Offset-2 loop
                Read(Input_File, tmp);
                Write(Output_File, tmp);
            end loop;
        end;

        for I in Data'Range loop
            Write(Output_File, Data(I));
        end loop;

        Put_Line("Wrote modified data");


        Set_Index(Input_File, 
                  Byte_IO.Count(Final_Bytes'First));
            
        for I of Final_Bytes loop
            Read(Input_File, I);
        end loop;

        for I of Final_Bytes loop
            Write(Output_File, I);
        end loop;
        
    end;

    Put_Line("[+] Image inverse complete");

end Main;