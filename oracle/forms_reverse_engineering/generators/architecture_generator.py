class ArchitectureGenerator:

    def generate(self, model):

        doc = "# System Architecture\n\n"

        doc += "## Forms\n"

        for f in model.forms:
            doc += f"- {f}\n"

        doc += "\n## Packages\n"

        for p in model.packages:
            doc += f"- {p}\n"

        doc += "\n## Tables\n"

        for t in model.tables:
            doc += f"- {t}\n"

        return doc