import os

from model.system_model import SystemModel

from parsers.package_parser import PackageParser

from analyzers.call_graph_analyzer import CallGraphAnalyzer

from generators.markdown_generator import MarkdownGenerator

from generators.plantuml_generator import PlantUMLGenerator


model = SystemModel()

PACKAGES_DIR = "input/plsql/packages"

DOCS_DIR = "docs"

os.makedirs(DOCS_DIR, exist_ok=True)


print("Parsing packages...")

pkg_parser = PackageParser(PACKAGES_DIR)

if not os.path.isdir(PACKAGES_DIR):
    print(f"Aviso: diretório de pacotes não encontrado: {PACKAGES_DIR}")
    print("Crie o diretório e adicione os arquivos de pacote PL/SQL para análise, ou ajuste PACKAGES_DIR.")
    packages = {}
else:
    packages = pkg_parser.parse_all()


call_analyzer = CallGraphAnalyzer()

for pkg, ast in packages.items():

    for proc in ast["procedures"]:

        model.add_procedure(proc, pkg)

    for func in ast["functions"]:

        model.add_function(func, pkg)

    for table in ast["tables"]:

        model.add_table(table)

    for rule in ast["rules"]:

        model.add_rule(rule)

    calls = call_analyzer.build(ast, pkg)

    for c in calls:

        model.add_call(c[0], c[1])


print("Generating documentation...")

md = MarkdownGenerator()

rules_doc = md.generate_business_rules(model.business_rules)

with open(f"{DOCS_DIR}/business_rules.md", "w", encoding="utf-8") as f:

    f.write(rules_doc)


uml = PlantUMLGenerator()

call_diagram = "@startuml\n"

for src, tgt in model.call_graph:

    call_diagram += f"{src} --> {tgt}\n"

call_diagram += "@enduml"

with open(f"{DOCS_DIR}/call_graph.puml", "w", encoding="utf-8") as f:

    f.write(call_diagram)


print("Analysis complete")
print("Procedures:", len(model.procedures))
print("Functions:", len(model.functions))
print("Tables:", len(model.tables))
print("Rules:", len(model.business_rules))