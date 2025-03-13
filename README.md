# NeuralVideoCoding_Hardware

## Contribuintes:
- Denis Lemke Maass
- Vanessa Aldrighi 


## Descrição

O NVC_hardware é um projeto focado no desenvolvimento de um programa em VHDL capaz de implementar uma solução de codificação de vídeo baseada em aprendizado de máquina diretamente em hardware. 

## Objetivos

  - Implementação em VHDL: Desenvolvimento completo do programa em linguagem de descrição de hardware (VHDL).
  - Parametrização: Projeto adaptável, permitindo ajustes nas configurações para atender diferentes requisitos de aplicação e cenários de uso.
  - Codificação Neural: Utilização de modelos de machine learning, com foco em redes neurais convolucionais, para melhorar a eficiência da compressão de vídeo.


## Requisitos
- fixed_pkg_c
- float_pkg_c

## Fully Connected com ReLU
Este projeto implementa uma rede neural parametrizável em VHDL com ponto flutuante, utilizando camadas totalmente conectadas (fully connected) com a função de ativação ReLU.

### Como funciona?

A rede pode ter qualquer número de camadas e neurônios, definidos por parâmetros. Cada neurônio recebe entradas de todos os neurônios da camada anterior e aplica a seguinte operação:
- Multiplicação: Cada entrada é multiplicada pelo seu peso correspondente.
- Soma: Os produtos são somados para calcular a saída bruta do neurônio.
- Ativação ReLU: Se o valor for negativo, ele é zerado; caso contrário, permanece o mesmo: ReLU(x) = max⁡(0,x)

A saída de uma camada se torna a entrada da próxima, permitindo a criação de redes profundas (deep neural networks) diretamente em FPGA.

Exemplos de uma camada:

![FullyConected](https://github.com/user-attachments/assets/22948894-dab9-42ec-88a2-d54ec7aa4942)



