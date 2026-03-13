import os

from parsers.forms_parser import FormsParser
from parsers.package_parser import PackageParser
from analyzers.dependency_analyzer import DependencyAnalyzer
from model.system_model import SystemModel
from generators.markdown_generator import MarkdownGenerator
from generators.plantuml_generator import PlantUMLGenerator


FORMS_DIR = "input/forms_xml"
PACKAGES_DIR = "input/plsql/packages"
DOCS_DIR = "docs"

PATHS = {
    "forms": os.path.join(DOCS_DIR, "forms"),
    "packages": os.path.join(DOCS_DIR, "packages"),
    "database": os.path.join(DOCS_DIR, "database")
}

os.makedirs(DOCS_DIR, exist_ok=True)
for p in PATHS.values():
    os.makedirs(p, exist_ok=True)

model = SystemModel()

print("Iniciando análise do sistema...\n")

for file in os.listdir(FORMS_DIR):

    if not file.endswith(".xml"):
        continue

    form_name = file.replace(".xml", "")

    print("Analisando:", form_name)

    parser = FormsParser(os.path.join(FORMS_DIR, file))

    blocks = parser.get_blocks()
    items = parser.get_items()
    triggers = parser.get_triggers()

    model.add_form(form_name)

    model.forms[form_name]["blocks"] = blocks
    model.forms[form_name]["items"] = items
    model.forms[form_name]["triggers"] = triggers

    analyzer = DependencyAnalyzer()
    tables, dep_packages = analyzer.analyze(triggers)

    for t in tables:
        model.add_table(t)

    for p in dep_packages:
        model.add_package(p)

    # TODO: currently form call extraction is not implemented in DependencyAnalyzer.
    # Keep placeholder for future form-call analysis.

print("\nAnálise concluída\n")

# -------------------------
# Parse packages para docs e modelos
# -------------------------

packages = {}
if os.path.isdir(PACKAGES_DIR):
    pkg_parser = PackageParser(PACKAGES_DIR)
    packages = pkg_parser.parse_all()
else:
    print(f"Aviso: diretório de pacotes não encontrado: {PACKAGES_DIR}")

for pkg in packages:
    model.add_package(pkg)

# -------------------------
# Gerar documentação
# -------------------------

md = MarkdownGenerator()

print("Gerando documentação Markdown...")

for form in model.forms:

    blocks = model.forms[form]["blocks"]
    items = model.forms[form]["items"]

    content = md.generate_forms_map(blocks, items)

    with open(f"{DOCS_DIR}/{form}_forms_map.md", "w", encoding="utf-8") as f:
        f.write(content)

# dependências globais

dep_content = md.generate_dependencies(
    model.tables,
    model.packages,
    model.form_calls
)

with open(f"{DOCS_DIR}/system_dependencies.md", "w", encoding="utf-8") as f:
    f.write(dep_content)


# -------------------------
# gerar diagramas
# -------------------------

uml = PlantUMLGenerator()

print("Gerando diagramas...")

for form in model.forms:

    diagram = uml.generate_dependency_diagram(
        form,
        model.tables,
        model.packages
    )

    with open(f"{DOCS_DIR}/{form}_dependency_diagram.puml", "w", encoding="utf-8") as f:
        f.write(diagram)

print("\nDocumentação gerada na pasta /docs")

from generators.forms_doc_generator import FormsDocGenerator

forms_gen = FormsDocGenerator()

for form_name, form_data in model.forms.items():

    content = forms_gen.generate(
        form_name,
        form_data["blocks"],
        form_data["items"]
    )

    with open(f"{PATHS['forms']}/{form_name}.md", "w") as f:
        f.write(content)

from generators.packages_doc_generator import PackageDocGenerator

pkg_gen = PackageDocGenerator()

for pkg, ast in packages.items():

    doc = pkg_gen.generate(pkg, ast)

    with open(f"{PATHS['packages']}/{pkg}.md", "w") as f:
        f.write(doc)

from generators.database_doc_generator import DatabaseDocGenerator

db_gen = DatabaseDocGenerator()

db_doc = db_gen.generate(model.tables)

with open(f"{PATHS['database']}/tables.md", "w") as f:
    f.write(db_doc)

from generators.database_doc_generator import DatabaseDocGenerator

db_gen = DatabaseDocGenerator()

db_doc = db_gen.generate(model.tables)

with open(f"{PATHS['database']}/tables.md", "w") as f:
    f.write(db_doc)

from generators.architecture_generator import ArchitectureGenerator

arch = ArchitectureGenerator()

arch_doc = arch.generate(model)

with open(f"{DOCS_DIR}/architecture.md", "w") as f:
    f.write(arch_doc)                      

try:
    from generators.manual_generator import ManualGenerator

    man = ManualGenerator()
    manual = man.generate(model)

    with open(f"{DOCS_DIR}/manual_funcional.md", "w", encoding="utf-8") as f:
        f.write(manual)
except Exception as e:
    print(f"Aviso: ManualGenerator não disponível, pulando geração de manual. {e}")    