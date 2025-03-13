library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.myPack.all;

--Fully conected

entity neuralLayer is
    generic (
        INPUT_SIZE  : positive := 2;  -- Quantidade de entradas em cada neurônio
        OUTPUT_SIZE : positive := 2   -- Quantidade de neurônios na camada
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic; 
        inputs   : in  std_logic_vector(INPUT_SIZE*32-1 downto 0); -- Entradas 32 bits
        weights  : in  std_logic_vector(INPUT_SIZE*OUTPUT_SIZE*32-1 downto 0); -- Pesos 32 bits
        outputs  : out std_logic_vector(OUTPUT_SIZE*32-1 downto 0) -- Saída 32 bits
    );
end entity neuralLayer;


architecture Behavioral of neuralLayer is
    
    -- Definição de um array para armazenar as somas dos neurônios
    type float32_array is array (0 to OUTPUT_SIZE-1) of float32;
    signal sum : float32_array;
    signal relu_out : float32_array;

 -- Função ReLU para ativação
    function relu(input_val : float32) return float32 is
    begin
        if input_val < 0.0 then
            return to_float(0.0);
        else
            return input_val;
        end if;
    end function;
    
begin
    process(clk)
        variable local_sum : float32;
        variable local_input : float32;
        variable local_weight : float32;
        variable local_product : float32;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                for j in 0 to OUTPUT_SIZE-1 loop
                    sum(j) <= to_float(0.0);  
                end loop;
            else
                for j in 0 to OUTPUT_SIZE-1 loop
                    local_sum := to_float(0.0);  
                    for i in 0 to INPUT_SIZE-1 loop  
                        local_input  := to_float(inputs((i+1)*32-1 downto i*32));  
                        local_weight := to_float(weights((j*INPUT_SIZE + i + 1)*32-1 downto (j*INPUT_SIZE + i)*32)); 
                        
                        local_product := local_input * local_weight;  
                        local_sum := local_sum + local_product;
                    end loop;
                    sum(j) <= local_sum; -- Atualiza sum(j) no final
		    relu_out(j) <= relu(local_sum);
                end loop;
            end if;
        end if;
    end process;

    
    -- Conversão da saída para std_logic_vector
    output_convert_inst: for j in 0 to OUTPUT_SIZE-1 generate
        outputConvert_inst: outputConvert
            port map (
                in_float32 => relu_out(j),
                out_std_logic_vector => outputs((j+1)*32-1 downto j*32)
            );
    end generate;
    
end Behavioral;


