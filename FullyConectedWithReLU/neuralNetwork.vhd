library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.myPack.all;

entity neuralNetwork is
    generic (
        INPUT_SIZE        : positive := 2;  
        LAYER_SIZES       : positive := 2;  
        NEURONS_PER_LAYER : positive := 2   
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        inputs   : in  std_logic_vector(INPUT_SIZE*32-1 downto 0);
        weights  : in  std_logic_vector(LAYER_SIZES*NEURONS_PER_LAYER*NEURONS_PER_LAYER*32-1 downto 0);
        outputs  : out std_logic_vector(NEURONS_PER_LAYER*32-1 downto 0)
    );
end entity neuralNetwork;

architecture arch of neuralNetwork is

    -- Matriz de pesos por camada
    type weight_array is array (0 to LAYER_SIZES-1) of std_logic_vector(NEURONS_PER_LAYER*NEURONS_PER_LAYER*32-1 downto 0);
    signal weight_matrices : weight_array;

    -- Saída de cada camada
    type layer_output_array is array (0 to LAYER_SIZES-1) of std_logic_vector(NEURONS_PER_LAYER*32-1 downto 0);
    signal layer_output : layer_output_array;

    -- Entrada de cada camada
    type layer_input_array is array (0 to LAYER_SIZES-1) of std_logic_vector(NEURONS_PER_LAYER*32-1 downto 0);
    signal layer_inputs : layer_input_array;

begin

    -- Atribuir pesos diretamente
    gen_weights: for i in 0 to LAYER_SIZES-1 generate
        weight_matrices(i) <= weights((i+1)*NEURONS_PER_LAYER*NEURONS_PER_LAYER*32-1 downto i*NEURONS_PER_LAYER*NEURONS_PER_LAYER*32);
    end generate;

    -- Primeira camada recebe os inputs diretamente
    layer_inputs(0) <= inputs;

    layer_inst0: entity work.neuralLayer
        generic map (
            INPUT_SIZE  => INPUT_SIZE,
            OUTPUT_SIZE => NEURONS_PER_LAYER
        )
        port map (
            clk      => clk,
            reset    => reset,
            inputs   => layer_inputs(0),
            weights  => weight_matrices(0),
            outputs  => layer_output(0)
        );

    -- Gerar camadas intermediárias
    layer_gen: for i in 1 to LAYER_SIZES-1 generate
        layer_inputs(i) <= layer_output(i-1); -- Passa saída da camada anterior para a próxima

        layer_inst: entity work.neuralLayer
            generic map (
                INPUT_SIZE  => NEURONS_PER_LAYER,
                OUTPUT_SIZE => NEURONS_PER_LAYER
            )
            port map (
                clk      => clk,
                reset    => reset,
                inputs   => layer_inputs(i), 
                weights  => weight_matrices(i),
                outputs  => layer_output(i)
            );
    end generate;

    -- Atribuir saída final
    outputs <= layer_output(LAYER_SIZES-1);

end architecture arch;

