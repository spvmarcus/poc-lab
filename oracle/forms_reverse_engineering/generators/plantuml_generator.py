class PlantUMLGenerator:

    def generate_navigation_diagram(self, model):

        uml = "@startuml\n\n"

        for src, tgt in model.navigation:

            uml += f"{src} --> {tgt}\n"

        uml += "\n@enduml"

        return uml
    
    def generate_erd(self, tables, relations):

        uml = "@startuml\n\n"

        for t in tables:

            uml += f"entity {t}\n"

        uml += "\n"

        for col, ref in relations:

            uml += f"{col} --> {ref}\n"

        uml += "\n@enduml"

        return uml


    def generate_dependency_diagram(self, form, tables, packages):

        uml = "@startuml\n\n"

        uml += f"package {form} {{\n"

        uml += f"  [{form}]\n"

        uml += "}\n\n"

        for t in sorted(tables):

            uml += f"{form} --> {t}\n"

        for p in sorted(packages):

            uml += f"{form} --> {p}\n"

        uml += "\n@enduml"

        return uml