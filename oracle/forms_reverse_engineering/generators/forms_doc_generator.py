class FormsDocGenerator:

    def generate(self, form_name, blocks, items):

        doc = f"# Form {form_name}\n\n"

        doc += "## Blocks\n"

        for b in blocks:
            doc += f"- {b}\n"

        doc += "\n## Items\n"

        for i in items:
            doc += f"- {i}\n"

        return doc