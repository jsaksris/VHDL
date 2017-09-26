library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is 
  port(
    clk : in std_logic;
    c_select : in std_logic_vector (3 downto 0);
    output : out std_logic_vector (10 downto 0)
  );
end ROM;

architecture v1 of ROM is 

type ReadOM is array (0 to 15) of std_logic_vector(10 downto 0);

signal rom1 : ReadOM;

begin
 
  start: process(clk, c_select)
  begin
     if clk = '1' and clk'event then
     output <= rom1(to_integer(unsigned(c_select)));
     end if;
  end process; 
end v1;
