library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.myPack.all;

entity tb_neuralNetwork is
end entity;

architecture tb of tb_neuralNetwork is

    -- Parâmetros da rede neural
    constant INPUT_SIZE         : positive := 2;
    constant LAYER_SIZES        : positive := 2;
    constant NEURONS_PER_LAYER  : positive := 2;

    -- Sinais do testbench
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal inputs   : std_logic_vector(INPUT_SIZE*32-1 downto 0);
    signal weights  : std_logic_vector(LAYER_SIZES*NEURONS_PER_LAYER*NEURONS_PER_LAYER*32-1 downto 0);
    signal outputs  : std_logic_vector(NEURONS_PER_LAYER*32-1 downto 0);

    -- Período do clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instância da rede neural
    uut: entity work.neuralNetwork
        generic map (
            INPUT_SIZE        => INPUT_SIZE,
            LAYER_SIZES       => LAYER_SIZES,
            NEURONS_PER_LAYER => NEURONS_PER_LAYER
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
        loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de entrada
    stimulus_process: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 2 * CLK_PERIOD;  -- Mantém reset por pelo menos 2 ciclos de clock
        reset <= '0';
        wait for CLK_PERIOD;

        -- Entrada 1: (2.0, -1.5)
        inputs <= to_slv(to_float(2)) & to_slv(to_float(3));

        weights <= to_slv(to_float(1))  & to_slv(to_float(1)) &
                   to_slv(to_float(1))  & to_slv(to_float(1)) &
                   to_slv(to_float(1))  & to_slv(to_float(1)) &
                   to_slv(to_float(1)) & to_slv(to_float(1));

        -- Pesos (exemplo arbitrário)
      --  weights <= to_slv(to_float(4.1))  & to_slv(to_float(0)) &
      --             to_slv(to_float(4.9))  & to_slv(to_float(0)) &
       --            to_slv(to_float(1))  & to_slv(to_float(0)) &
        --           to_slv(to_float(0)) & to_slv(to_float(1.5));

        --wait for 5 * CLK_PERIOD;

        -- Entrada 2: (1.0, 3.0)
        --inputs <= to_slv(to_float(1.0)) & to_slv(to_float(0));
--	wait for 5 * CLK_PERIOD;

        -- Finaliza simulação
        wait;
    end process;

end architecture;

