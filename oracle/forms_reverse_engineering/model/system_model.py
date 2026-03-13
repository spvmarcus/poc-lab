class SystemModel:

    def __init__(self):

        self.forms = {}

        self.packages = {}

        self.form_calls = []

        self.tables = set()

        self.navigation = []

        self.dependencies = []

        self.procedures = {}

        self.functions = {}

        self.call_graph = []

        self.business_rules = []


    def add_table(self, table):

        self.tables.add(table)


    def add_procedure(self, name, package):

        self.procedures[name] = package


    def add_function(self, name, package):

        self.functions[name] = package


    def add_form(self, form_name):

        if form_name not in self.forms:
            self.forms[form_name] = {
                "blocks": [],
                "items": [],
                "triggers": []
            }


    def add_package(self, package):

        self.packages[package] = True


    def add_form_call(self, caller, callee):

        self.form_calls.append((caller, callee))


    def add_call(self, caller, callee):

        self.call_graph.append((caller, callee))


    def add_rule(self, rule):

        self.business_rules.append(rule)