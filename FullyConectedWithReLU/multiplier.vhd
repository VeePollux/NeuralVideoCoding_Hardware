library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;

entity multiplier is
    port (
        a  : in  float32;
        b  : in  float32;
        p  : out float32
    );
end multiplier;

architecture Behavioral of multiplier is
begin
    p <= a * b;
end Behavioral;
