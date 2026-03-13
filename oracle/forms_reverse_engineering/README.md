# forms_reverse_engineering

Estrutura do projeto:

- `analyzer.py` - análise de dados de formulário (função `analyze`).
- `forms_parser.py` - parser de texto de formulários (função `parse`).
- `dependency_analyzer.py` - analisa dependências entre campos (função `analyze_dependencies`).
- `diagram_generator.py` - gera texto/diagrama (função `create_diagram`).
- `doc_generator.py` - gera documentação a partir de dados analisados (função `generate_documentation`).
- `run_analysis.py` - orquestra o pipeline e imprime resultados.
- `forms_xml/` - diretório para XML ou fontes de formulário.
- `docs/` - documentação de triggers e mapeamentos.

Como usar:

```bash
python run_analysis.py
```

Ajuste `run_analysis.run(raw_text)` para o seu input real de formulários.
