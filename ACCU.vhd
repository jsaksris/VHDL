library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ACCU is 
  port(
   clk : in std_logic;
   rst : in std_logic;
   ce : in std_logic;
   D_in: in std_logic_vector(22 downto 0);
   D_out: out std_logic_vector(31 downto 0)
  );

end ACCU;

architecture v1 of ACCU is
   signal mem: std_logic_vector(31 downto 0):=(others=>'0');
   signal ce_mem: std_logic:='0';
begin
  process(clk, rst, ce)
  begin
    if rst = '1' then
       mem <= x"00000000";
       ce_mem <= '0';
    elsif clk = '1' and clk'event then
       if ce /= ce_mem and ce = '1' then
          mem <= std_logic_vector(unsigned(mem) +unsigned( D_in)); 
       end if;
       D_out <= mem;
    end if;
  end process;
end v1;
