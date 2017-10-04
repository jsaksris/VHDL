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

begin

end;
