# TASKS.md - Master Task Registry

## Status Codes
- `PENDING` — Not yet started
- `IN_PROGRESS` — Actively being worked on
- `WAITING` — Blocked on someone/something external
- `COMPLETED` — Done and confirmed
- `DELAYED` — Past deadline, not resolved

## Priority Codes
- `URGENT` — Must happen today, blocking something critical
- `HIGH` — Should happen today/tomorrow, significant impact
- `MEDIUM` — Should happen this week
- `LOW` — Do when time allows
- `SCHEDULED` — Has a date, not time-sensitive

## Categories
- `PERSONAL` — Individual tasks
- `BUSINESS` — Company/operational tasks
- `DELEGATED` — Assigned to someone else
- `FOLLOW_UP` — Requires verification of completion

## Task Template

```
## [PRIORITY] Task Name
- **Category:** PERSONAL | BUSINESS | DELEGATED | FOLLOW_UP
- **Status:** PENDING | IN_PROGRESS | WAITING | COMPLETED | DELAYED
- **Assigned to:** [name]
- **Deadline:** [date/time]
- **Follow-up:** [date/time or "none"]
- **Reminder:** [frequency, e.g. "daily until resolved"]
- **Dependencies:** [list or "none"]
- **Description:** [what needs to happen]
- **Notes:** [history, context, blockers]
```

---

## Tasks

### URGENT

### 1. Checar Estoque i9Store USA
- **Category:** BUSINESS
- **Status:** IN_PROGRESS
- **Assigned to:** Vivi (i9Store USA)
- **Deadline:** 2026-05-22
- **Follow-up:** 2026-05-21
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Full inventory check at i9Store USA location. Needed to plan stock burn campaign.
- **Notes:** Blocks i9Store stock burn campaign. Need return date from Vivi.

### 2. Resolver Ton (Dinheiro travado na conta)
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-22
- **Follow-up:** 2026-05-20
- **Reminder:** none
- **Dependencies:** none
- **Description:** Ton platform — funds frozen in account. Urgent resolution needed.
- **Notes:** **URGENT: Passar para Gabi resolver AMANHÃ (20/05).** Follow-up agendado para 21/05.

### 3. Resolver com a Thieme Cobrança Extra dos Fretes
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** 2026-05-20
- **Reminder:** none
- **Dependencies:** none
- **Description:** Dispute extra freight charges from Thieme. **URGENT: Need meeting tomorrow to resolve.**
- **Notes:** Thieme charged US$ 2,000 — correct amount should be ~US$ 1,300. Thieme requested a meeting. **Must schedule and attend meeting tomorrow (20/05) to close this.**

### 4. Pegar estorno da compra K-Array
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-23
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Process refund for K-Array purchase (Panasonic).
- **Notes:** External vendor.

### HIGH

### 5. Comprar FX30 com Yuri Delta
- **Category:** BUSINESS
- **Status:** IN_PROGRESS
- **Assigned to:** Will (monitoramento), Gabi (OC), Will (fornecedor)
- **Deadline:** 2026-05-22
- **Follow-up:** 2026-05-21
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Purchase Sony FX30 camera from Yuri Delta to fulfill iFood order. **End-to-end workflow:** Venda sem estoque → Comprar do fornecedor → Gabi lança OC → Will monitora → Entrega ao cliente.
- **Notes:** Complementary to #6 (iFood sale). **Workflow breakdown:**
  - **5.1 Confirmar existência e detalhes da venda iFood**
    - **Status:** ⚠️ Em aberto — bloqueio potencial no pagamento/cadastro da empresa no sistema iFood
    - **Responsável:** Gabi + Jeniffer (execução), Will (monitoramento)
    - **Ação:** Gabi verificar cadastro da empresa no iFood; Jeniffer verificar forma de pagamento
    - **Deliverable:** Comprovante/pedido da venda iFood (número, valor, prazo de entrega ao cliente)
    - **Deadline:** 20/05/2026 (hoje)
  - **5.2 Validar pronto-entrega FX30 com Yuri**
    - **Status:** ⚠️ Confirmado ontem — reconfirmar dia 21/05
    - **Responsável:** Will
    - **Ação:** Contatar Yuri para validar que o equipamento continua à pronta entrega
    - **Deadline:** 21/05/2026
  - **5.3 Definir fornecedor FX30 (Yuri Delta)**
    - **Status:** ✅ Feito
    - **Responsável:** Will
  - **5.4 Lançar OC no sistema da i9**
    - **Status:** ⏸️ Dependente de 5.1
    - **Responsável:** Gabi
    - **Deliverable:** OC gerada e enviada para Yuri
    - **Deadline:** Assim que 5.1 resolvido
  - **5.5 Confirmar recebimento da OC pelo Yuri**
    - **Status:** ⏸️ Dependente de 5.4
    - **Responsável:** Will
    - **Deliverable:** Confirmação de pedido pelo fornecedor (email/sistema)
    - **Deadline:** Assim que 5.4 resolvido
  - **5.6 Monitorar entrega do FX30**
    - **Status:** ⏸️ Dependente de 5.5
    - **Responsável:** Will (fornecedor) + Comercial (cliente iFood)
    - **Deliverable:** Alerta se houver risco de atraso
    - **Deadline:** Conforme prazo do Yuri + prazo com iFood
- **Deadline final:** 22/05/2026
- **Risco principal:** 5.1 travado no cadastro do iFood. Se Gabi/Jeniffer não resolverem hoje, a cadeia inteira trava.

### 6. Verificar venda iFood (Compra e Prazos de entrega)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-21
- **Follow-up:** 2026-05-22
- **Reminder:** none
- **Dependencies:** none
- **Description:** Check iFood sale — purchase terms and delivery deadlines.
- **Notes:** Market expansion. **Linked to #5:** This sale generated the demand to buy FX30.

### 7. Levantar compras necessárias i9Store (Pedidos Encomenda)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-24
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** "Checar Estoque i9Store USA" (#1)
- **Description:** Compile necessary purchases/orders for i9Store.
- **Notes:** Needs inventory check from USA first. **Breakdown needed:**
  - 7.1 Definição de timeframe (próximos 7 dias ou longo prazo?)
  - 7.2 Template de pedidos (existente ou criar do zero?)
  - 7.3 Validação das compras (Will, Erika ou ambos?)
  - 7.4 Precificação (preços atuais ou pesquisa necessária?)

### 8. Pegar data de retorno Vivi i9Store USA
- **Category:** BUSINESS
- **Status:** COMPLETED
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** 2026-05-25
- **Reminder:** none
- **Dependencies:** none
- **Description:** Get Vivi's return date from i9Store USA.
- **Notes:** Vivi retorna **22/05 (sexta)**. Follow-up agendado para 26/05.

### 9. Ver com Juan possíveis coletas para envio
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-22
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Check with Juan for possible pickups/shipping.
- **Notes:** Logistics coordination.

### 10. Resolver Pedido da Adventista Norte
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-22
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Resolve order for Adventista Norte.
- **Notes:** Client order.



### 12. Venda Cage C50 para Canon
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-23
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** C50 sale to Canon.
- **Notes:** Major sale.

### 13. Proposta Painel de LED Parkstation Atualizada
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-22
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Update Parkstation LED panel proposal.
- **Notes:** Vendor/partner. **Breakdown needed:**
  - 13.1 Proposta atual existe? (PDF/DOC qual versão?)
  - 13.2 O que mudou desde a última versão? (preço, specs, quantidade, condições?)
  - 13.3 Prazo de entrega da proposta para o cliente?
  - 13.4 Specs técnicas atuais do painel LED Parkstation disponíveis?
  - 13.5 Quem revisa/aprova a proposta final? (Will, jurídico, financeiro?)

### 14. Proposta Unidade Móvel Nigéria
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-25
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Draft mobile unit proposal for Nigeria.
- **Notes:** International project.

### 15. Projeto Record RJ Master
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-30
- **Follow-up:** 2026-05-26
- **Reminder:** none
- **Dependencies:** none
- **Description:** Record RJ Master project management.
- **Notes:** Major client project.

### MEDIUM

### 16. Workflow do CRM no Central; Ygor
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Cido
- **Deadline:** 2026-05-28
- **Follow-up:** 2026-05-25
- **Reminder:** none
- **Dependencies:** none
- **Description:** CRM workflow in Central system with Ygor.
- **Notes:** System integration.

### 17. Checar status de implantação do CRM
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Cido
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** none
- **Description:** Check CRM deployment status.
- **Notes:** With Cido.

### 18. Página i9Store de acompanhamento de pedidos
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Cido
- **Deadline:** 2026-06-05
- **Follow-up:** 2026-06-01
- **Reminder:** none
- **Dependencies:** none
- **Description:** Build i9Store order tracking page.
- **Notes:** Web development.

### 19. Calculo de Frete para pedidos nacionais (API Central)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Cido
- **Deadline:** 2026-06-05
- **Follow-up:** 2026-06-01
- **Reminder:** none
- **Dependencies:** none
- **Description:** Freight calculation API for national orders via Central.
- **Notes:** System integration.

### 20. Botão Marketplace em Orçamentos (Para mudar o PDF)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Cido
- **Deadline:** 2026-06-05
- **Follow-up:** 2026-06-01
- **Reminder:** none
- **Dependencies:** none
- **Description:** Add marketplace button to quotes (PDF generation).
- **Notes:** System feature.

### 21. Alinhamento de Catalogo com nova precificação Marketplace
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-28
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Align catalog with new marketplace pricing.
- **Notes:** Pricing update.

### 22. i9Store; Campanha para Queimar Estoque (Depende da Checagem de Estoque i9Store USA)
- **Category:** BUSINESS
- **Status:** WAITING
- **Assigned to:** Will
- **Deadline:** 2026-06-01
- **Follow-up:** 2026-05-28
- **Reminder:** none
- **Dependencies:** "Checar Estoque i9Store USA"
- **Description:** Stock burn campaign for i9Store. Blocked until USA inventory check.
- **Notes:** Blocks on item #1.

### 23. Contratação Comercial i9Store; Jeniffer
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Jeniffer
- **Deadline:** 2026-05-30
- **Follow-up:** 2026-05-27
- **Reminder:** none
- **Dependencies:** none
- **Description:** Commercial hiring for i9Store. Managed by Jeniffer.
- **Notes:** HR/Sales.

### 24. Financeiro; Sistema de conciliação bancária
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Erika
- **Deadline:** 2026-06-10
- **Follow-up:** 2026-06-05
- **Reminder:** none
- **Dependencies:** none
- **Description:** Bank reconciliation system setup.
- **Notes:** Financial system.

### 25. Financeiro i9Store; Contas a Receber
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Erika
- **Deadline:** 2026-05-27
- **Follow-up:** 2026-05-28
- **Reminder:** none
- **Dependencies:** none
- **Description:** i9Store accounts receivable management.
- **Notes:** Finance.

### 26. Financeiro i9Store; Contas a Pagar
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Erika
- **Deadline:** 2026-05-27
- **Follow-up:** 2026-05-28
- **Reminder:** none
- **Dependencies:** none
- **Description:** i9Store accounts payable management.
- **Notes:** Finance.

### 27. Financeiro i9Store; Recebimentos Atrasados
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Erika
- **Deadline:** 2026-05-27
- **Follow-up:** 2026-05-28
- **Reminder:** none
- **Dependencies:** none
- **Description:** i9Store delayed receipts management.
- **Notes:** Finance.

### 28. Processo de Vendas i9Store Brasil Marketplace (Objetivo/Brainstorm)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-28
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Brainstorm objectives for i9Store Brazil marketplace sales process.
- **Notes:** Strategic planning.

### 29. Analise de IA de Tickets; realizar testes
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-30
- **Follow-up:** 2026-05-28
- **Reminder:** none
- **Dependencies:** none
- **Description:** AI ticket analysis — run tests.
- **Notes:** Innovation/automation.

### HIGH

### 43. RigWheels; Proposta Comercial para Leo (Comercial)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Leo wants to purchase another RigWheels unit. Already messaged Jeniffer and supplier — must send proposal tomorrow.
- **Notes:** High urgency. Proposal deadline: tomorrow. Comms sent: Jeniffer (internal), supplier (external).

### 30. Ordem de Compra Campsnap
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-22
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Process Campsnap purchase order.
- **Notes:** Delegated to Gabi.

### 31. Pedido de Venda Rede Palavra
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-22
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Create sales order for Rede Palavra.
- **Notes:** Delegated to Gabi.

### 32. Packing List Venda Rede Palavra
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-22
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Prepare packing list for Rede Palavra sale.
- **Notes:** Delegated to Gabi.

### 33. Alinhar frete Rede Palavra com Juan
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-22
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Coordinate freight with Juan for Rede Palavra shipment.
- **Notes:** Gabi + Juan coordination.

### 34. Organizar Estoque para envio Pipo
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-23
- **Follow-up:** 2026-05-22
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Organize stock for Pipo shipment.
- **Notes:** Delegated to Gabi.

### 35. Prioridades de cadastro NiSi Catalogo
- **Category:** DELEGATED
- **Status:** PENDING
- **Assigned to:** Gabi
- **Deadline:** 2026-05-24
- **Follow-up:** 2026-05-23
- **Reminder:** daily until complete
- **Dependencies:** none
- **Description:** Prioritize NiSi catalog registration tasks.
- **Notes:** Delegated to Gabi.

### 44. Painel de LED; Orçamento para Hiro
- **Category:** BUSINESS
- **Status:** IN_PROGRESS
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Hiro requested LED panel quote — approximately 2.5m wide x 1.5m high. Already notified Jeniffer (commercial). RFQ sent to Jerry at Recience (China supplier). Awaiting updated proposal — expected tomorrow morning.
- **Notes:** Dimensions: 2.5m x 1.5m. External supplier: Recience (Jerry). Internal: Jeniffer (Comercial). Follow-up: check proposal receipt tomorrow AM. **Proposal deadline: tomorrow (20/05).**
- **Update 21:49:** Message sent to Jerry. Awaiting updated proposal AM 20/05.

### 45. Venda Primo Rico; Pedido de Compra Kaique (Equipamentos)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Combo task: (1) Call Kaique to process equipment purchase order — funding source: R$150,000 receivable; (2) Prime Rico sale — track purchases, terms, and payments.
- **Notes:** Action: call Kaique AM 20/05. Follow-up: confirm order placement. Prime Rico sale tracking deadline 24/05.

### 46. Compra Sony FX3; Negociar prazo com Merlin
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-20
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** Purchase Sony FX3 camera — negotiate payment terms with supplier Merlin.
- **Notes:** Supplier: Merlin. Action: contact Merlin to get payment deadline/terms.

### MEDIUM

### 37. Compras a Realizar (i9Store USA)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-25
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** "Checar Estoque i9Store USA" (#1)
- **Description:** Identify purchases needed for i9Store USA.
- **Notes:** Depends on inventory check.

### 38. Contas a Pagar (i9Store USA)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-25
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** none
- **Description:** Compile i9Store USA accounts payable list.
- **Notes:** USA operations.

### 39. Contas a Receber (i9Store USA)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-25
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** none
- **Description:** Compile i9Store USA accounts receivable list.
- **Notes:** USA operations.

### 40. Estoque (i9Store USA)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-25
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** "Checar Estoque i9Store USA" (#1)
- **Description:** Full inventory assessment for i9Store USA.
- **Notes:** Needed for stock burn campaign planning.

### SCHEDULED

### 41. Church Tech Expo (Quarta e Quinta-feira)
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-28
- **Follow-up:** 2026-05-24
- **Reminder:** none
- **Dependencies:** none
- **Description:** Stand exhibition at Church Tech Expo. Need to prepare team, tasks and pending items.
- **Notes:** Two-day event. Need team meeting to finalize everything.

### 42. Reunião Church Tech Expo - Planning
- **Category:** BUSINESS
- **Status:** PENDING
- **Assigned to:** Will
- **Deadline:** 2026-05-20 14:00
- **Follow-up:** none
- **Reminder:** none
- **Dependencies:** none
- **Description:** In-person meeting at Inove to plan Church Tech Expo stand tasks and pending items.
- **Attendees:** Cido, Ana Freitas (Gerente de Marketing), Ailton (Gerente de Projetos e Eventos)
- **Notes:** Tomorrow at 14:00, presencial at Inove.

---

*Last updated: 2026-05-19*
