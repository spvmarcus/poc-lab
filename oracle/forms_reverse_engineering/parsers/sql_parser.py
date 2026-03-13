class SQLParser:

    def parse_tables(self, ddl):

        tables = []

        for line in ddl.splitlines():

            line = line.strip().upper()

            if line.startswith("CREATE TABLE"):

                name = line.split()[2]

                tables.append(name)

        return tables