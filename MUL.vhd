library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUL is 
  port(
    clk : in std_logic;
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(10 downto 0);
    C : out std_logic_vector(22 downto 0)
   );
end MUL;

architecture v1 of MUL is
signal n1 : unsigned (11 downto 0) := (others => '0');
signal n2 : unsigned (10 downto 0) := (others => '0');
begin 
multiply: process(clk)
  begin
    if clk = '0' and clk'event then
     n1 <= unsigned(A);
     n2 <= unsigned(B);
     C <= std_logic_vector(n1*n2);
    end if;
  end process; 
  


end v1;
