# remotes::install_github("curso-r/munifacil")
arquivo <- "data-raw/dados-cetesb-output/2022.csv"
readr::guess_encoding(arquivo)


raw_csv_2022 <-
  readr::read_csv(
    arquivo,
    col_names = c(
      # define o nome das colunas
      "ugrhi",
      "municipio",
      "concessao",
      "populacao_urbana",
      "atendimento_coleta_porc",
      "atendimento_tratamento_porc",
      "eficiencia",
      "carga_poluidora_potencial",
      "carga_poluidora_remancescente",
      "ictem",
      "municipio_litoraneo_com_emissario",
      "corpo_receptor"
    ),

    # encoding dos dados
    locale = readr::locale(encoding = "UTF-8"),

    # Quantas linhas para pular no CSV antes de começar a ler os dados.
    skip = 4
  )

dados_2022 <- raw_csv_2022 |>
  dplyr::filter(municipio != "Qualidade das Águas Interiores no Estado de São Paulo") |>
  tidyr::drop_na(ugrhi) |>
  dplyr::select(ugrhi:ictem, -concessao) |>
  dplyr::mutate(dplyr::across(
    c(
      populacao_urbana,
      atendimento_coleta_porc,
      atendimento_tratamento_porc,
      eficiencia,
      carga_poluidora_potencial,
      carga_poluidora_remancescente,
      ictem
    ),
    .fns = ~ readr::parse_number(
      .x,
      locale = readr::locale(decimal_mark = ","),
      na = c("N.D")
    )
  )) |>
  dplyr::mutate(ano = 2022,
                uf = "SP",
                .before = everything())

# Adicionar coluna IBGE
dados_2022_tidy <- dados_2022 |>
  dplyr::mutate(
    municipio = dplyr::if_else(
      municipio == "SanAtor aAcnatnôgnuiáo do",
      "Santo Antônio do
Aracanguá",
      municipio
    )
  ) |>
  munifacil::limpar_colunas(col_muni = municipio, col_uf = uf) |>
  munifacil::incluir_codigo_ibge() |>
  dplyr::rename(codigo_ibge = id_municipio) |>
  dplyr::select(-c(uf_join, muni_join, manual, atencao, starts_with("existia_"))) |>
  dplyr::relocate(codigo_ibge, .after = municipio)


dados_2022_tidy |>
  readr::write_csv("data-raw/dados-cetesb-tidy/2022.csv")
