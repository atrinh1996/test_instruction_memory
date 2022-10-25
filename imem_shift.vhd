library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IMEM is
-- The instruction memory is a byte addressable, little-endian, read-only memory
-- Reads occur continuously
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

architecture behavioral of IMEM is
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal imemBytes:ByteArray;
-- add and load has been updated
begin
process(Address)
variable addr:integer;
variable first:boolean:=true;
begin
    if(first) then
        -- LSL X9, X10, 3 // X9 := 1 << 3 = 1 * 8 = 8
        imemBytes(3) <= "11010011";
        imemBytes(2) <= "01100000";
        imemBytes(1) <= "00001101";
        imemBytes(0) <= "01001001";
        -- no op
      --   imemBytes(3) <= "00000000";
      --   imemBytes(2) <= "00000000";
      --   imemBytes(1) <= "00000000";
      --   imemBytes(0) <= "00000000";

        -- LSR X9, X12, 1 // X9 := 8 >> 1 = 8 / 2 = 4
          imemBytes(7) <= "11010011";
          imemBytes(6) <= "01000000";
          imemBytes(5) <= "00000101";
          imemBytes(4) <= "10001001";
        -- no op
      --   imemBytes(7) <= "00000000";
      --   imemBytes(6) <= "00000000";
      --   imemBytes(5) <= "00000000";
      --   imemBytes(4) <= "00000000";

        -- ADDI X21, X21, -32 //  X21 := 0 + -32 = -32
        imemBytes(11) <= "10010001";
        imemBytes(10) <= "00111111";
        imemBytes(9)  <= "10000010"; 
        imemBytes(8)  <= "10110101";
        -- no op
        -- imemBytes(11) <= "00000000";
        -- imemBytes(10) <= "00000000";
        -- imemBytes(9)  <= "00000000"; 
        -- imemBytes(8)  <= "00000000";
        -- ADDI X21, X21, 32 // X21 := 32
      --   imemBytes(11) <= "10010001";
      --   imemBytes(10) <= "00000000";
      --   imemBytes(9)  <= "10000010"; 
      --   imemBytes(8)  <= "10110101";


        -- LSL X9, X21, 3 // X9 := -32 * 8 = -256
        imemBytes(15) <= "11010011";
        imemBytes(14) <= "01100000";
        imemBytes(13) <= "00001110";
        imemBytes(12) <= "10101001";
        -- no op
      --   imemBytes(15) <= "00000000";
      --   imemBytes(14) <= "00000000";
      --   imemBytes(13) <= "00000000";
      --   imemBytes(12) <= "00000000";
      -- ADDI X9, X21, 0 
      -- imemBytes(15) <= "10010001";
      -- imemBytes(14) <= "00000000";
      -- imemBytes(13) <= "00000010";
      -- imemBytes(12) <= "10101001";

        -- LSR X9, X9, 5 // X9 := -256 / 32 = -8
        imemBytes(19) <= "11010011";
        imemBytes(18) <= "01000000";
        imemBytes(17) <= "00010101";
        imemBytes(16) <= "00101001";
        -- no op
      --   imemBytes(19) <= "00000000";
      --   imemBytes(18) <= "00000000";
      --   imemBytes(17) <= "00000000";
      --   imemBytes(16) <= "00000000";

        -- nop
        imemBytes(23)  <= "00000000";
        imemBytes(22)  <= "00000000";  
        imemBytes(21)  <= "00000000";  
        imemBytes(20)  <= "00000000";

        imemBytes(31)  <= "00000000";
        imemBytes(30)  <= "00000000";  
        imemBytes(29)  <= "00000000";  
        imemBytes(28)  <= "00000000";  
        imemBytes(27)  <= "00000000";
        imemBytes(26)  <= "00000000";  
        imemBytes(25)  <= "00000000";  
        imemBytes(24)  <= "00000000"; 

        imemBytes(39)  <= "00000000";
        imemBytes(38)  <= "00000000";  
        imemBytes(37)  <= "00000000";  
        imemBytes(36)  <= "00000000";
        imemBytes(35)  <= "00000000";
        imemBytes(34)  <= "00000000";  
        imemBytes(33)  <= "00000000";  
        imemBytes(32)  <= "00000000"; 

        imemBytes(47)  <= "00000000";
        imemBytes(46)  <= "00000000";  
        imemBytes(45)  <= "00000000";  
        imemBytes(44)  <= "00000000"; 
        imemBytes(43)  <= "00000000";
        imemBytes(42)  <= "00000000";  
        imemBytes(41)  <= "00000000";  
        imemBytes(40)  <= "00000000";  

        imemBytes(55)  <= "00000000";
        imemBytes(54)  <= "00000000";  
        imemBytes(53)  <= "00000000";  
        imemBytes(52)  <= "00000000"; 
        imemBytes(51)  <= "00000000";
        imemBytes(50)  <= "00000000";  
        imemBytes(49)  <= "00000000";  
        imemBytes(48)  <= "00000000";

        imemBytes(63)  <= "00000000";
        imemBytes(62)  <= "00000000";  
        imemBytes(61)  <= "00000000";  
        imemBytes(60)  <= "00000000"; 
        imemBytes(59)  <= "00000000";
        imemBytes(58)  <= "00000000";  
        imemBytes(57)  <= "00000000";  
        imemBytes(56)  <= "00000000";





      first:=false;
   end if;
   addr:=to_integer(unsigned(Address));
   if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      ReadData<=imemBytes(addr+3) & imemBytes(addr+2) & imemBytes(addr+1) & imemBytes(addr+0);
   else report "Invalid IMEM addr. Attempted to read 4-bytes starting at address " &
      integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
      severity error;
   end if;

end process;

end behavioral;

