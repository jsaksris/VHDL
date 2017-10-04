library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity seq is 
  port(
    clk : in std_logic;
    ce : in std_logic;
    rst: in std_logic;
    MULT_done : in std_logic;--needed for a state 
    ACCU_done : out std_logic;
    counter : out std_logic_vector (4 downto 0);
    DPRAM_go : out std_logic;
    ROM_go : out std_logic;
    MUL_go: out std_logic;
    ACCU_go: out std_logic
  );
end seq;

architecture v1 of seq is
type state_type is (s0,s1,s2,s3,s4,s5);
signal state, next_state : state_type;
signal ce_mem: std_logic;
signal count: std_logic_vector (4 downto 0);

begin
counter <= count;

  block_f: process (clk,ce,rst,state,MULT_done,count)
  begin
    case state is
      when s0 =>
	if rst = '1' then 
          next_state <= s0;
        elsif clk ='1' and clk'event and ce = '1' then
	  next_state <= s1; -- load ram
        end if;

      when s1 =>
	if ce = '0' and ce /= ce_mem then 
          next_state <= s6; --reset before s2
        else 
           if count < "11111" then
              next_state <= s1;
           else 
              next_state <= s5;
           end if;
        end if;  
      
      when s5 => 
	if ce = '0' and ce /= ce_mem then 
              next_state <= s2;
        else
              next_state <= s5;
        end if;
      when s6 => next_state <= s2;
      when s2 => --calculating
	if ce ='1' and ce /= ce_mem then
          next_state <= s1;
        else 
          if MULT_done = '0' then
              next_state <= s2;
          else 
              next_state <= s3;
          end if;
        end if;
      when s3 => --accumulating
         if count < "11111" then
           next_state <= s2;
         else 
           next_state <= s4;
         end if;

      when s4 => 
         if ce = '1' and ce /= ce_mem then
           next_state <= s1;
         else 
           next_state <= s4;
         end if;
    end case;
  end process;

  block_m: process(clk,rst)
  begin
     if rst = '1' then
	state <= s0;
     elsif clk = '1' and clk'event then
        end if;
        state <= next_state;
        ce_mem <= ce;
     end if;
  end process;
   
  block_g: process(state)
  begin
    case state is 
      when s0 => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '0';
                 count <= "00000";  
      when s1 => DPRAM_go <= '1'; MUL_go <= '0'; ACCU_go <= '0';
                 count <= std_logic_vector(unsigned(count) + 1);
      when s5 => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '0';
                 count <= "00000";
      when s6 => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '0';
                 count <= "00000";
      when s2 => DPRAM_go <= '0'; MUL_go <= '1'; ACCU_go <= '0'; 
      when s3 => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '1';
      when s4 => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '0';
                 count <= std_logic_vector(unsigned(count) + 1);
                 ACCU_done <= '1';
      when others => DPRAM_go <= '0'; MUL_go <= '0'; ACCU_go <= '0';

    end case;
  end process;

end v1;
