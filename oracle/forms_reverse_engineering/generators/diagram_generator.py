def generate_call_graph(call_graph):

    uml = "@startuml\n\n"

    for src, tgt in call_graph:

        uml += f"{src} --> {tgt}\n"

    uml += "\n@enduml"

    return uml