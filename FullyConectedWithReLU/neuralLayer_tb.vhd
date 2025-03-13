library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.myPack.all;

entity neuralLayer_tb is
end entity;

architecture tb of neuralLayer_tb is

    constant INPUT_SIZE  : positive := 2;
    constant OUTPUT_SIZE : positive := 2;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal inputs   : std_logic_vector(INPUT_SIZE*32-1 downto 0);
    signal weights  : std_logic_vector(INPUT_SIZE*OUTPUT_SIZE*32-1 downto 0);
    signal outputs  : std_logic_vector(OUTPUT_SIZE*32-1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.neuralLayer
        generic map (
            INPUT_SIZE  => INPUT_SIZE,
            OUTPUT_SIZE => OUTPUT_SIZE
        )
        port map (
            clk     => clk,
            reset   => reset,
            inputs  => inputs,
            weights => weights,
            outputs => outputs
        );

    -- Geração do clock 
    clk_process: process
    begin
        wait for CLK_PERIOD / 2;
        clk <= not clk;
    end process;

    -- Estímulos de entrada
    process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;

        -- Estímulos de entrada 
        inputs  <= to_slv(to_float(2)) & to_slv(to_float(3)); --Valores de entrada
        weights <= to_slv(to_float(1))  & to_slv(to_float(2)) & --Pesos para o último neurônio
                   to_slv(to_float(5))  & to_slv(to_float(0)); --Pesos para o primeiro neurônio

        wait for 50 ns;

        -- Nova entrada
        -- Estímulos de entrada 
        inputs  <= to_slv(to_float(2)) & to_slv(to_float(3)); --Valores de entrada
        weights <= to_slv(to_float(4.1))  & to_slv(to_float(0)) & --Pesos para o último neurônio
                   to_slv(to_float(4.9))  & to_slv(to_float(0)); --Pesos para o primeiro neurônio

        wait for 50 ns;

        -- Finaliza simulação
        wait;
    end process;

end architecture;
