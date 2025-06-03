converter_pdf_para_csv <- function(ano,
                                   pasta_input = "data-raw/dados-cetesb",
                                   pasta_output = "data-raw/dados-cetesb-output",
                                   api_key = "f7pakihzcyb5") {
  # Função para converter PDF para CSV
  pdftables::convert_pdf(
    input_file = paste0(pasta_input, "/", ano, ".pdf"),
    output_file = paste0(pasta_output, "/", ano, ".csv"),
    api_key = api_key
  )
}
