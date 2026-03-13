class DatabaseDocGenerator:

    def generate(self, tables):

        doc = "# Database Tables\n\n"

        for t in sorted(tables):
            doc += f"- {t}\n"

        return doc