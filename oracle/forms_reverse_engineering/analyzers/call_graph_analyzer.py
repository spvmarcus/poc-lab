class CallGraphAnalyzer:

    def build(self, ast, package):

        calls = []

        for pkg, proc in ast["calls"]:

            calls.append((package, f"{pkg}.{proc}"))

        return calls