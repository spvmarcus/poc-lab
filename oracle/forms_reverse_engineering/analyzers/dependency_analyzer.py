from parsers.plsql_parser import PLSQLParser


class DependencyAnalyzer:

    def __init__(self):

        self.parser = PLSQLParser()

    def analyze(self, triggers):

        tables = set()

        packages = set()

        for code in triggers:

            for t in self.parser.extract_tables(code):

                if "." in t:
                    t = t.split(".")[-1]

                tables.add(t)

            for p in self.parser.extract_packages(code):

                packages.add(p)

        return tables, packages