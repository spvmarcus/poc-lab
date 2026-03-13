class SystemGraph:

    def __init__(self):

        self.nodes = set()

        self.edges = []

    def add_node(self, name):

        self.nodes.add(name)

    def add_edge(self, source, target, type):

        self.edges.append((source, target, type))