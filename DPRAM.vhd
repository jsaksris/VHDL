library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity DPRAM is 
  generic (num_words : integer;
	   width_words : integer);
  port(
   clk : in std_logic;
   A_address : in std_logic_vector(4 downto 0); 
   B_address : in std_logic_vector(4 downto 0);
   A_rw  : in std_logic; -- 1 is read
   B_rw  : in std_logic;
   A_in : in std_logic_vector(width_words-1 downto 0);
   B_in : in std_logic_vector(width_words-1 downto 0);
   A_out : out std_logic_vector(width_words-1 downto 0);
   B_out : out std_logic_vector(width_words-1 downto 0)
  );

end DPRAM;


architecture v1 of DPRAM is 
type RAM is array (0 to num_words-1) of std_logic_vector(width_words-1 downto 0);
signal ram1 : RAM;

begin 

  start: process(clk,A_rw, B_rw)  
  begin
     if clk ='1' and clk'event then 
      if A_rw = '1' then
	A_out <= ram1(to_integer(unsigned(A_address)));
      else
	ram1(to_integer(unsigned(A_address))) <= A_in;
      end if;
      
      if B_rw = '1' then
        B_out <= ram1(to_integer(unsigned(B_address)));
      else
        ram1(to_integer(unsigned(B_address))) <= B_in;
      end if;
     end if;
  end process;
  
end v1;

