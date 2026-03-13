import os
from parsers.plsql_ast_parser import PLSQLASTParser


class PackageParser:

    def __init__(self, folder):

        self.folder = folder

        self.ast_parser = PLSQLASTParser()


    def parse_all(self):

        packages = {}

        for file in os.listdir(self.folder):

            if not file.endswith(".sql"):
                continue

            path = os.path.join(self.folder, file)

            with open(path) as f:

                code = f.read()

            ast = self.ast_parser.parse(code)

            pkg = file.replace(".sql", "")

            packages[pkg] = ast

        return packages