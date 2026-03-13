import re


class PLSQLASTParser:

    def parse(self, code):

        ast = {
            "procedures": [],
            "functions": [],
            "calls": [],
            "tables": [],
            "rules": []
        }

        ast["procedures"] = self.extract_procedures(code)
        ast["functions"] = self.extract_functions(code)
        ast["calls"] = self.extract_calls(code)
        ast["tables"] = self.extract_tables(code)
        ast["rules"] = self.extract_business_rules(code)

        return ast


    def extract_procedures(self, code):

        pattern = r'PROCEDURE\s+([A-Z0-9_]+)'
        return re.findall(pattern, code.upper())


    def extract_functions(self, code):

        pattern = r'FUNCTION\s+([A-Z0-9_]+)'
        return re.findall(pattern, code.upper())


    def extract_calls(self, code):

        pattern = r'([A-Z0-9_]+)\.([A-Z0-9_]+)\('
        return re.findall(pattern, code.upper())


    def extract_tables(self, code):

        tables = re.findall(r'FROM\s+([A-Z0-9_\.]+)', code.upper())
        tables += re.findall(r'JOIN\s+([A-Z0-9_\.]+)', code.upper())
        tables += re.findall(r'INTO\s+([A-Z0-9_\.]+)', code.upper())

        return tables


    def extract_business_rules(self, code):

        rules = []

        pattern = r'IF\s+(.*?)\s+THEN'

        matches = re.findall(pattern, code.upper(), re.DOTALL)

        for m in matches:
            rules.append(m.strip())

        return rules
