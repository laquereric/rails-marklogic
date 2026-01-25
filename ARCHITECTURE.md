# Architecture

## Purpose
This document states the irreversible architectural decisions for this project.

## Core Principle
Evidence → Views → UIResources → Presentation

## Separation of Concerns
- Evidence is persisted and secured in MarkLogic
- Views are deterministic derivations over evidence
- UIResources are client-facing contracts
- Presentation is entirely decoupled

## Non-Goals
- No presentation logic in core systems
- No raw evidence in UIResources
- No UI-specific assumptions in MCP Doctor

## System Roles
- MarkLogic: system of record and security authority
- MCP Doctor: diagnostic reasoning and view generation
- MCP-UI (future): presentation-only consumer

## Security Boundary
All access to evidence is mediated by MarkLogic permissions.

## Change Policy
Any change violating these principles is considered architectural drift.