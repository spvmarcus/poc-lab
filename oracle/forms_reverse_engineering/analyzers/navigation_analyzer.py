from parsers.plsql_parser import PLSQLParser


class NavigationAnalyzer:

    def __init__(self):

        self.parser = PLSQLParser()

    def analyze(self, triggers):

        forms = set()

        for code in triggers:

            found = self.parser.extract_forms(code)

            for f in found:

                forms.add(f)

        return forms