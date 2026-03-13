class MarkdownGenerator:

    def generate_forms_doc(self, form_name, blocks, items):

        md = f"# Form {form_name}\n\n"

        md += "## Blocks\n"

        for b in blocks:

            md += f"- {b}\n"

        md += "\n## Items\n"

        for i in items:

            md += f"- {i}\n"

        return md


    def generate_system_doc(self, model):

        md = "# System Dependencies\n\n"

        md += "## Tables\n"

        for t in sorted(model.tables):

            md += f"- {t}\n"

        md += "\n## Packages\n"

        for p in sorted(model.packages):

            md += f"- {p}\n"

        md += "\n## Navigation\n"

        for src, tgt in model.navigation:

            md += f"- {src} → {tgt}\n"

        return md


    def generate_forms_map(self, blocks, items):

        md = "## Blocks\n"

        for b in blocks:

            md += f"- {b}\n"

        md += "\n## Items\n"

        for i in items:

            md += f"- {i}\n"

        return md


    def generate_dependencies(self, tables, packages, form_calls):

        md = "# Dependencies\n\n"

        md += "## Tables\n"

        for t in sorted(tables):

            md += f"- {t}\n"

        md += "\n## Packages\n"

        for p in sorted(packages):

            md += f"- {p}\n"

        md += "\n## Form Calls\n"

        for src, tgt in form_calls:

            md += f"- {src} → {tgt}\n"

        return md
    
    def generate_business_rules(self, rules):

        md = "# Regras de Negócio Detectadas\n\n"

        for i, r in enumerate(rules, 1):

            md += f"{i}. {r}\n"

        return md