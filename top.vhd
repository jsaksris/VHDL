library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
   enable : in std_logic;
   data_in : in std_logic_vector (11 downto 0);
   clk : in std_logic;
   rst : in std_logic;
   dataout : out std_logic_vector (31 downto 0);
   dataval : out std_logic
)
end top;

architecture v1 of top is
component DPRAM 
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
end component;

component ROM 
 port(
    clk : in std_logic;
    c_select : in std_logic_vector (3 downto 0);
    output : out std_logic_vector (10 downto 0)
  );
end component;

component MUL
  port(
    clk : in std_logic;
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(10 downto 0);
    C : out std_logic_vector(22 downto 0)
   );
end component;

component ACCU
  port(
   clk : in std_logic;
   rst : in std_logic;
   ce : in std_logic;
   D_in: in std_logic_vector(22 downto 0);
   D_out: out std_logic_vector(31 downto 0)
  );

end component;

component seq 
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
end component;

signal address: std_logic_vector(4 downto 0);
signal dpram_go: std_logic;
signal mul_go: std_logic;

signal ram_out: std_logic_vector(11 downto 0); 
signal rom_out: std_logic_vector(10 downto 0);
signal mul_out: std_logic_vector(22 downto 0);
signal data_out_mem: std_logic_vector(31 downto 0);
signal accu_out_mem: std_logic_vector;
signal accu_go_latch: std_logic;
signal accu_ce: std_logic;

type state_type is (s0,s1,s2,s3);
signal state, next_state :state_type;

begin

process(clk,rst)
begin
  if rst = '1' then
  elsif clk = '1' and clk'event
    data_out <= data_out_mem;
    data_val <= accu_out_mem;
  end if;
end process; 

accu_latch: process(state)
begin
  case state is 
    when s0 =>
       if accu_go_latch = '1' then
	  next_state <= s1;
       else 
          next_state <= s0;
    when s1 =>
       next_state <= s2;
    when s2 =>
       next_state <= s3;
    when s3 =>
       next_state <= s0;
end process;

update_: process(clk,rst)
begin
  if rst = '1' then
  elsif clk = '1' and clk'event then
    state <= next_state; 
  end
end 

block_g: process(state) 
begin
  case state is 
    when s3 => accu_ce <= '1';
    when others => accu_ce <= '0';
end


DP: DPRAM 
  generic map(
  num_words => 32,
  width_words => 12
  );
  port map(
   clk => clk,
   A_address => address,  
   B_address => 
   A_rw => not dpram_go,
   B_rw =>
   A_in => data_in,
   B_in =>
   A_out => ram_out,
   B_out => 
  );

ROM1:ROM port map(
  clk => clk,
  c_select => address(3 downto 0),
  output => rom_out
);

MUL1: MUL port map(
  clk => clk,
  A => ram_out,
  B => rom_out,
  C => mul_out
);

ACCU1: ACCU port map(
  clk => clk,
  rst => rst,
  ce => accu_ce,
  D_in => mul_out,
  D_out => data_out_mem
)

seq1: seq port map(
    clk => clk,
    ce => enable,
    rst => rst,
    MULT_done 
    ACCU_done => accu_out_mem, 
    counter => address,
    DPRAM_go => dpram_go,
    ROM_go 
    MUL_go => mul_go,
    ACCU_go => accu_go_latch
)

end;
