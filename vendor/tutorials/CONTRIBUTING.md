# Contributing Tutorials

This guide explains how to add or improve tutorials in `vendor/tutorials`.

The goal is consistency without bureaucracy. Follow the principles below, not rigid rules.

## Learning Philosophy

All tutorials follow **Applied Transfer Learning (ATL)**:

- Teach one concrete idea
- Let the user verify success
- Show how the idea transfers elsewhere

If a tutorial does not enable transfer, it likely belongs in reference or explanation docs instead.

## Tutorial Structure

Tutorials are organized by **domains** and **units**:

- A **domain** is a conceptual area (e.g. Querying, Data Modeling)
- A **unit** is a single tutorial teaching one primary idea

Every domain **must** have a `README.md`.
Each tutorial unit lives in its own directory.

## When to Add a New Tutorial

Add a tutorial when:
- A user needs to *learn* something by doing
- The idea is reusable beyond one specific task
- Success can be observed or verified

Do not add tutorials for:
- API listings
- Exhaustive option coverage
- One-off debugging notes

## Writing a Tutorial

Use the unit template in `shared/unit-template.md`.

Keep these principles in mind:

- One primary learning goal
- Explain *why*, not just *what*
- Prefer clarity over completeness
- Keep scope small

## Verification

Every tutorial must include a **Verification** section.

Verification can be simple:
- Expected output
- State change
- Observable behavior

If the user cannot tell whether they succeeded, the tutorial is incomplete.

## Transfer

Every tutorial must include a **Transfer** section.

Transfer answers:
- Where else does this idea apply?
- What new problems can the user now solve?

This is what distinguishes tutorials from walkthroughs.

## Suggested Order

Domains may suggest an order for tutorials.

Suggested order:
- Reflects conceptual dependency only
- Is never enforced
- Exists to help new users orient themselves

## Style Guidelines

- Write for users, not contributors
- Use clear, direct language
- Avoid internal jargon when possible
- Prefer short sections over long prose

## Improving Existing Tutorials

Improvements are welcome when they:
- Clarify goals
- Improve verification
- Strengthen transfer explanations
- Reduce unnecessary complexity

Avoid expanding scope unless the tutorial clearly benefits from it.
