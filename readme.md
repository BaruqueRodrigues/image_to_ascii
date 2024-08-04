---
editor: visual
title: Readme
toc-title: Table of contents
---

## Imagem para ASCII

Transforma uma imagem em arte ASCII usando R.

## Descrição

Este repo apresenta a função em `imagem_para_ascii` que transforma
imagens em formato `.jpg` em arte ASCII, que é uma técnica que utiliza
caracteres do conjunto ASCII para representar imagens.

## O que é Arte ASCII?

Arte ASCII é um método de criar imagens simples usando apenas caracteres
do conjunto ASCII, como letras, números e símbolos. Este tipo de arte
remonta aos primeiros dias da computação, quando as imagens gráficas
eram limitadas ou inexistentes. Ao converter imagens em arte ASCII, é
possível apreciar como os caracteres podem ser organizados para
representar visuais complexos.

## Isso é interessante pra um Cientista de Dados?

Respondendo rápido? Acho que não, afinal foi uma brincadeira que fiz pra
tentar surpreender minha esposa quando ela chegou do trabalho, todavia
pra entender como a função funciona, e como o processo de transformação
de imagem para ascii tem alguns elementos de datasci que você tem que
entender:

1.  **Processamento de Imagem**: Entender como as imagens são
    carregadas, redimensionadas e transformadas.

2.  **Manipulação de Dados**: Explorar técnicas de manipulação de dados
    usando pacotes como `dplyr` e `purrr`.

3.  **Visualização de Dados**: Utilizar o `ggplot2` para visualização de
    dados de uma maneira inovadora.

4.  **Otimização e Eficiência**: Compreender a otimização de funções e o
    gerenciamento de recursos ao trabalhar com grandes conjuntos de
    dados de imagem.

## Como Usar

### Instalação

Para utilizar a função, primeiro instale os pacotes necessários:

::: cell
``` {.r .cell-code}
install.packages(c("imager", "gtools", "dplyr", "purrr", "ggplot2", "here"))
```
:::

A construção da função:

::: cell
``` {.r .cell-code}
imagem_para_ascii <- function(path,
                              resize_img = .5){
  #diretório da imagem
  path_image <-  here::here(path)
  
  # Interrompe se a imagem não for em jpg
  if(!grepl('.jpg', path_image)){
    stop('A imagem deve ser em formato .jpg')
  }
  
  #carregando a imagem
  amor <- imager::load.image(path_image)
  
  #caracteres em ascii
  asc <- gtools::chr(38:126)
  
  # Função que transforma em texto
  transforma_em_texto <- function(texto){
    imager::implot(
      imager::imfill(50,50, val = 1),
      text(25, 25, texto, cex = 5)
    ) %>% imager::grayscale() %>% mean()
  }
  
  
  # Ordenando os caracteres ascii por brilho
  brilho_asc <-  dplyr::tibble(asc) %>% 
    dplyr::mutate(
      brilho = purrr::map_dbl(
        asc,
        ~transforma_em_texto(.x)
      )
    ) %>% 
    dplyr::arrange(brilho)
  
  # preparando o dataset para plotagem
  dataset_imagem <- imager::grayscale(amor) %>%
    imager::imresize(resize_img)  %>% 
    as.data.frame() %>%
    dplyr::tibble() %>% 
    dplyr::mutate(
      quantized_values = cut(value, length(brilho_asc$asc)) %>% as.integer(),
      brilho = brilho_asc$asc[quantized_values]
    )
  
  # constroi o datavis
  dataset_imagem %>% 
    ggplot2::ggplot(
      aes(
        x,y
      )
    )+
    ggplot2::geom_text(
      aes(
        label = brilho
      ), size = 1
    )+
    ggplot2::scale_y_reverse() +
    ggplot2::theme_void()
  
}
```
:::

PS: se for usar a função, carrega ela na pasta R, onde ela está com o
Roxygen Skeleton

### Parâmetros

-   `path`: Diretório para a imagem que será transformada em ASCII. A
    imagem deve estar no formato `.jpg`.

-   `resize_img`: Redimensiona a imagem para um tamanho menor. O padrão
    é 0.5.

### Fazendo uso

Visualizando a imagem original

::: cell
``` {.r .cell-code}
# Diretório da imagem
path_image <- here::here('data/amor.jpg')

# Processando a imagem no R
amor <- imager::load.image(path_image)

#Plotando ela no viewer
plot(amor)
```

::: cell-output-display
![](readme_files/figure-markdown/unnamed-chunk-4-1.png)
:::
:::

Visualizando a imagem em Ascii

::: cell
``` {.r .cell-code}
imagem_para_ascii(path_image)
```

::: cell-output-display
![](readme_files/figure-markdown/unnamed-chunk-5-1.png)
:::
:::
