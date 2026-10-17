import {
  OPI_ENVELOPE_FIELD_ALIASES,
  OPI_HEADER_ALIASES,
  OPI_PATH_ALIASES,
  OPI_REQUEST_FIELDS_BY_PATH,
  OPI_RESPONSE_FIELDS_BY_PATH,
  type OpFieldPair,
} from './opi-registry.generated'

export function resolveOpiWirePath(semanticPath: string): string {
  return OPI_PATH_ALIASES[semanticPath] ?? semanticPath
}

export function applyOpiHeaderAliases(
  headers: Record<string, string | number | boolean | undefined | null>,
): Record<string, string | number | boolean | undefined | null> {
  const next: Record<string, string | number | boolean | undefined | null> = {}
  for (const [name, value] of Object.entries(headers)) {
    if (value === undefined || value === null) continue
    const wireName = OPI_HEADER_ALIASES[name] ?? name
    next[wireName] = value
  }
  return next
}

export function aliasRequestBody(semanticPath: string, body: unknown): unknown {
  return deepRemap(body, OPI_REQUEST_FIELDS_BY_PATH[semanticPath], 'semanticToWire')
}

export function semanticResponseBody(semanticPath: string, body: unknown): unknown {
  return deepRemap(body, OPI_RESPONSE_FIELDS_BY_PATH[semanticPath], 'wireToSemantic')
}

export function readSemanticEnvelope(wire: Record<string, unknown>): {
  code: string
  message: string
  requestId: string
  result: unknown
} {
  const code = String(readEnvelopeField(wire, 'code') ?? '')
  const message = String(readEnvelopeField(wire, 'message') ?? '')
  const requestId = String(readEnvelopeField(wire, 'requestId') ?? '')
  const result = readEnvelopeField(wire, 'result') ?? null
  return { code, message, requestId, result }
}

function readEnvelopeField(wire: Record<string, unknown>, original: string): unknown {
  if (wire[original] !== undefined) return wire[original]
  const alias = OPI_ENVELOPE_FIELD_ALIASES[original]
  if (alias && wire[alias] !== undefined) return wire[alias]
  return undefined
}

function deepRemap(
  value: unknown,
  pairs: readonly OpFieldPair[] | undefined,
  direction: 'semanticToWire' | 'wireToSemantic',
): unknown {
  if (!pairs?.length) return value
  const table = new Map<string, string>()
  for (const pair of pairs) {
    const from = direction === 'semanticToWire' ? pair.original : pair.alias
    const to = direction === 'semanticToWire' ? pair.alias : pair.original
    if (from !== to) table.set(from, to)
  }
  return walk(value, table)
}

function walk(value: unknown, table: Map<string, string>): unknown {
  if (Array.isArray(value)) return value.map((item) => walk(item, table))
  if (!value || typeof value !== 'object') return value
  const next: Record<string, unknown> = {}
  for (const [key, child] of Object.entries(value as Record<string, unknown>)) {
    next[table.get(key) ?? key] = walk(child, table)
  }
  return next
}
