import re


class PLSQLParser:

    def extract_tables(self, code):

        tables = re.findall(
            r'FROM\s+([A-Z0-9_\.]+)',
            code.upper()
        )

        return tables


    def extract_packages(self, code):

        packages = re.findall(
            r'([A-Z0-9_]+)\.',
            code.upper()
        )

        return packages


    def extract_forms(self, code):

        forms = re.findall(
            r"CALL_FORM\('([A-Z0-9_]+)'",
            code.upper()
        )

        forms += re.findall(
            r"OPEN_FORM\('([A-Z0-9_]+)'",
            code.upper()
        )

        return forms