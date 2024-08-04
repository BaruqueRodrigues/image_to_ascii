library(tidyverse)
library(cowplot)
library(imager)
library(here)

#https://dahtah.github.io/imager/ascii_art.html
# Acessando a imagem no diretório



imagem_para_ascii('data/amor.jpg')


path_image <- here::here('data/amor.jpg')

# Carregando ela dentro do ambiente do R 
amor <- load.image(path_image)

# caracteres ascii


transforma_em_texto <- function(texto){
  imager::implot(
    imager::imfill(50,50, val = 1),
    text(25, 25, texto, cex = 5)
  ) %>% imager::grayscale() %>% mean
}


# Ordenando os caracteres ascii por brilho
brilho_asc <-   tibble(asc) %>% 
  mutate(
    brilho = map_dbl(
      asc,
      ~transforma_em_texto(.x)
    )
  ) %>% 
  arrange(brilho)


#Convert image to grayscale, resize, convert to data.frame
dataset_imagem <- grayscale(amor) %>%
  imresize(.5)  %>% 
  as.data.frame() %>%
  tibble() %>% 
  mutate(
    quantized_values = cut(value, length(brilho_asc$asc)) %>% as.integer(),
    brilho = brilho_asc$asc[quantized_values]
  )

# Plotando a imagem
dataset_imagem %>% 
  ggplot(
    aes(
      x,y
    )
  )+
  geom_text(
    aes(
      label = brilho
    ), size = 1
  )+
  scale_y_reverse() +
  theme_void()


