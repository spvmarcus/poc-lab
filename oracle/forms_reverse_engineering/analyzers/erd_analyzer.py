import re


class ERDAnalyzer:

    def extract_relationships(self, ddl):

        relations = []

        pattern = r'FOREIGN KEY\s*\((.*?)\)\s*REFERENCES\s*([A-Z0-9_]+)'

        matches = re.findall(pattern, ddl.upper())

        for col, table in matches:

            relations.append((col, table))

        return relations