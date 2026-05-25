# Message Routing and Context — Specification

---

## Purpose

Define how messages are routed to the correct recipients, how context is maintained for each message, and how reply threading is managed. This protocol ensures that every operational message reaches its intended recipient with sufficient context to act, and that no message is sent without proper routing or context.

**What it is:** The rules for message routing, context attachment, and reply management for operational communication.
**What it is not:** A messaging platform. This protocol governs how the agent selects recipients, composes messages, and manages thread context using existing tools (exec, gog, messaging skills).

---

## Operational Semantics

Every operational message must answer four questions before it is sent:

1. **Who is the recipient?** (specific contact, group, or system)
2. **What is the context?** (task ID, relevant history, required attachments)
3. **What is the channel?** (email, Signal, Telegram, WhatsApp, etc.)
4. **What is the action?** (what the recipient is expected to do)

If any of these four cannot be answered, the message is NOT sent.

---

## Routing Rules

### MR1: Recipient Determination
For each task, the recipient is determined by:
- **Task definition:** The task's context specifies the intended recipient
- **Historical pattern:** The most recent communication in the task's thread
- **Explicit direction:** USER specifies the recipient in the task or command

If the recipient is ambiguous, the task is marked WAITING until the recipient is clarified. No message is sent to an ambiguous recipient.

### MR2: Channel Selection
The channel is determined by:
- **Recipient preference:** The channel the recipient has used historically
- **Task urgency:** T1/T2 tasks use the fastest available channel (email + Signal/WhatsApp if available)
- **Message type:** Contracts use email (legal requirement). Follow-ups use the channel of last contact.

If no channel is established, email is the default.

### MR3: Context Attachment
Every operational message MUST include in its context:
- **Task ID:** The task number or reference
- **Objective:** A one-line description of what this message is about
- **Relevant history:** The last 1-2 messages or facts from the thread (not the full thread)
- **Required action:** What the recipient is expected to do
- **Deadline:** Any deadline relevant to this message (if not in the original task)

Context is attached to the message body or in the task context field, depending on the channel.

### MR4: Reply Threading
All replies to a message must be sent within the same thread. New threads are only created when:
- The recipient has explicitly requested a new thread
- The subject has changed significantly (new topic)
- The existing thread is older than 30 days and the topic is still active

Reply threading ensures context continuity. Breaking a thread is a governance violation unless justified.

### MR5: Message Templates
Operational messages use structured templates to ensure consistency:

```
[Task #XXX] <Subject>

Hi <Name>,

<Context: 1-2 lines of relevant history>

<Action: What you need to do>
<Deadline: If applicable>

Regards,
Jarvis
```

Templates are not mandatory for casual messages, but are required for operational messages (payments, contracts, logistics, procurement).

### MR6: Multi-Recipient Messages
When a message has multiple recipients:
- One recipient is the primary addressee
- Other recipients are CC'd
- The primary addressee is identified in the message body
- All recipients share the same context (no selective context)

### MR7: Message Delivery Verification
For operational messages:
- **Email:** Delivery confirmation is logged if available
- **Signal/Telegram/WhatsApp:** Read receipt is logged if available
- If delivery confirmation is not available, the message is logged with the timestamp of sending as evidence

---

## Context Management Rules

### CM1: Thread Context Retention
For each active task thread, the following context is retained:
- All messages sent and received (in the task context or associated file)
- The most recent 5 messages from each side are loaded into the session context for reference
- Older messages are not loaded unless specifically requested

### CM2: Context Freshness
Thread context is refreshed:
- At the start of each session (latest 5 messages)
- After each message send/receive
- When a new message arrives (context is updated before the next action)

### CM3: Context Isolation
Thread context is isolated per task. Cross-task context leakage is prohibited. When working on task #47, the agent does not load context from task #48 unless explicitly directed by USER.

### CM4: Context Archiving
When a task is COMPLETED:
- The thread context is archived in the task's context field
- The context is NOT deleted
- The context is searchable for 30 days via task lookup

---

## Message Examples

### Example 1: Payment Follow-Up (T1)
```
Recipient: Marco Guimaraes (Canon)
Channel: Email + Signal (both)
Context: Task #47 — PO#308672, $9,620 Panasonic nota at risk
Template:

[Task #47] Follow-up: Payment PO#308672

Hi Marco,

Following up on PO#308672 for the EOS C50. The Panasonic invoice ($9,620) is overdue and we need to resolve this to maintain the supply chain.

Please confirm payment status at your earliest convenience.

Regards,
Jarvis
```

### Example 2: Vendor Inquiry (T3)
```
Recipient: Merlin Distributor
Channel: Email
Context: Task #46 — Canon availability check
Template:

[Task #46] Inquiry: Canon EOS C50 Availability

Hi Merlin,

Received your message about Canon availability. Could you provide pricing and delivery timeline for the EOS C50? We have an active PO#308672 pending.

Regards,
Jarvis
```

### Example 3: Multi-Recipient (T2)
```
Recipients: Gabi (primary), Will (CC)
Channel: Email
Context: Task #48 — Panasonic nota $9,620
Template:

[Task #48] URGENT: Panasonic Invoice $9,620 — Overdue

Hi Gabi,

This invoice is 2 days overdue. The Panasonic payment is blocking our $9,620 revenue. Please issue the nota today.

Will (CC): Please ensure we have the correct billing details.

Regards,
Jarvis
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Recipient ambiguous | MR1: task marked WAITING; recipient clarification required before send |
| No channel established | MR2: email used as default; contact info updated once channel is established |
| Context missing | MR3: message is not sent; context is gathered before send |
| Thread broken | MR4: this is a governance violation; thread is re-established or a new task is created |
| Template violation | MR5: operational messages without structured format are flagged for review |
| Multi-recipient context leakage | MR6: this is a governance violation; each recipient gets the full shared context |
| Message delivery failure | MR7: failure is logged; retry after 24h; escalate to USER if retry fails |

---

## Constraints

- **No new messaging platform.** All messaging uses existing channels (email, Signal, Telegram, WhatsApp, gog).
- **No message parsing.** The agent reads messages but does not parse complex message formats.
- **No message queueing.** Messages are sent immediately upon completion of composition.
- **No auto-responses.** The agent does not send automated replies to operational messages.
- **No context encryption.** Context is stored in existing file locations; subject to existing security.
- **Backward compatible.** Existing messages are unaffected. Only new messages sent by the agent follow this protocol.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all routing rules (absolute)

---

*Every message has a recipient, a context, a channel, and an action. If any are missing, the message does not leave the agent.*
