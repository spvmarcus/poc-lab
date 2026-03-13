class ManualGenerator:

    def generate(self, model):

        doc = "# Manual Funcional do Sistema\n\n"

        doc += "## Regras de Negócio\n\n"

        for r in model.business_rules:
            doc += f"- {r}\n"

        doc += "\n## Fluxos Detectados\n"

        for src, tgt in model.navigation:
            doc += f"- {src} -> {tgt}\n"

        return doc