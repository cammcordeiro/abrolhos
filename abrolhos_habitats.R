library(tidyverse)

abrolhos_producao <- read.csv("abrolhos_producao.csv", dec=",")

abrolhos_producao %>%
  mutate(habitat = factor(habitat, levels = c("1", "2", "3", "controle_resp")),
         dif = ((o2_zero - o2_pd) - o2_resp)) %>% 
  pivot_longer(cols = c("o2_pd", "o2_resp"), values_to = "valor", names_to = "variavel") %>% 
  filter(variavel == "o2_pd") %>% 
  ggplot(aes(x = habitat, y = dif, color = habitat)) +
    geom_boxplot() +
    theme_classic() +
    theme(legend.position = "") +
    facet_grid(~ variavel)


abrolhos_producao %>%
  mutate(habitat = factor(habitat, levels = c("1", "2", "3", "controle_resp")),
         dif = ((o2_zero - o2_pd) - o2_resp)) %>% 
  pivot_longer(cols = c("o2_pd", "o2_resp"), values_to = "valor", names_to = "variavel") %>% 
  filter(variavel == "o2_pd") %>% 
  lme4::lmer(dif ~ habitat + (1|date) + (1|site), . ) %>%  
  emmeans::emmeans(., list(pairwise ~ habitat), adjust = "tukey")


# temperatura
temperatura <- bind_rows(
  read.csv("loggers/Abrolhos_controle_1_plancton.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c1_planton"),
  read.csv("loggers/agua.csv", skip = 2, header = F, sep = ",")[, 2:3] %>%  
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "agua"),
  read.csv("loggers/ar.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "ar"),
  read.csv("loggers/controle_1_19112022.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c1_19-11"),
  read.csv("loggers/controle_1_21112022.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c1_20-11"),
  read.csv("loggers/controle_1.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c1"),
  read.csv("loggers/controle_2.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c2"),
  read.csv("loggers/controle_4_19112022_.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c4_19-11"),
  read.csv("loggers/controle_4_21112022.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c4_21-11"),
  read.csv("loggers/controle_4_branco.csv", skip = 2, header = F, sep = ",")[, 2:3] %>% 
    rename(data_hora = V2,
           temp = V3) %>% 
    mutate(trat = "c4_branco")
) %>% 
  separate(data_hora, into = c("data", "hora"), sep = " ") %>% 
  mutate(data = sub('(?<=.{6})', '20', data, perl=TRUE) %>% 
           as.POSIXct(., format = "%m/%d/%Y"))
         # hora = str_replace_all(hora, c("h" = ":", "1min" = "0", "0s" = "")),
         # data_hora = paste(data, hora) %>% 


