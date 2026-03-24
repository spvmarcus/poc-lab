# Landing Page Builder Skill

Crie landing pages de alta conversão seguindo este workflow:

## 1. Briefing da Landing Page

Colete informações essenciais:
- **Objetivo**: Captura de leads, venda, cadastro, webinar, etc.
- **Público-alvo**: Quem vai acessar? Qual dor/solução?
- **CTA principal**: O que o usuário deve fazer ao final?
- **Identidade visual**: Cores, fontes, tom de voz
- **Estrutura de seções**: Hero, benefícios, social proof, FAQ, etc.

## 2. Estrutura Recomendada

```
Landing Page:
├── Hero Section
│   ├── Headline (h1) - benefício claro
│   ├── Subheadline - contexto
│   ├── CTA Button
│   └── Imagem/ilustração
├── Social Proof
│   ├── Logo bar (clientes/parceiros)
│   └── Depoimentos
├── Features/Benefícios
│   ├── Problema → Solução
│   └── 3-6 cards de benefícios
├── Como Funciona (se aplicável)
├── Pricing/Planos (se aplicável)
├── FAQ
├── CTA Final
└── Footer (termos, contato)
```

## 3. Princípios de Conversão

- **Headline**: Foco no benefício, não no produto
- **CTA**: Visível, urgente, específico (ex: "Quero meu ebook grátis")
- **Escassez**: Se aplicável (prazo, vagas limitadas)
- **Social proof**: Testimonials, números, logos de clientes
- **Mobile-first**: Design responsivo desde o início
- **Velocidade**: Otimize imagens, minimize JS/CSS
- **Trust**: Selos, badges, garantias

## 4. Stack/Tecnologias

Use a stack mais adequada ao contexto:
- **HTML/CSS vanilla** → Páginas simples e rápidas
- **Tailwind CSS** → Desenvolvimento rápido com CSS utilitário
- **React/Vue** → Componentes reutilizáveis
- **Next.js** → SEO e performance
- **Landing page builders**: Carrd, Launchaco, etc.

## 5. Checklist de Qualidade

- [ ] Headline clara e focada em benefício
- [ ] CTA visível acima da dobra
- [ ] Formulário simples (máximo 4 campos)
- [ ] Mobile responsive
- [ ] Meta tags SEO completas
- [ ] Open Graph tags para redes sociais
- [ ] Performance otimizada (< 3s carregamento)
- [ ] Acessibilidade básica (contraste, alt text)
- [ ]analytics configurado (pageviews, conversões)

## 6. Workflow de Implementação

1. Criar arquivo `index.html` com estrutura semântica
2. Adicionar CSS (inline ou externo)
3. Implementar seções seguindo a estrutura
4. Adicionar interatividade mínima (JS para formulários)
5. Testar em mobile e desktop
6. Validar performance e acessibilidade
