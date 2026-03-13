class PackageDocGenerator:

    def generate(self, package_name, ast):

        doc = f"# Package {package_name}\n\n"

        doc += "## Procedures\n"

        for p in ast["procedures"]:
            doc += f"- {p}\n"

        doc += "\n## Functions\n"

        for f in ast["functions"]:
            doc += f"- {f}\n"

        doc += "\n## Tables Used\n"

        for t in ast["tables"]:
            doc += f"- {t}\n"

        return doc