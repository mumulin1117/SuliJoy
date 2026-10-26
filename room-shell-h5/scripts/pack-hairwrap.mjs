import { readFile, writeFile, readdir, lstat, mkdir } from 'node:fs/promises'
import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'node:crypto'
import { deflateSync, inflateSync } from 'node:zlib'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const args = process.argv.slice(2)
const input = path.resolve(root, args.includes('--input') ? args[args.indexOf('--input') + 1] : 'HairwrapKnotDrape')
const swift = path.resolve(root, '../JOiySuizoy/JOiySuizoy/HairwrapKnotDrape.swift')
const output = path.resolve(root, '../JOiySuizoy/JOiySuizoy/HairwrapKnotDrape/CoastalWeave.dat')
let source = await readFile(swift, 'utf8')
if (args.includes('--initialize')) {
  if (!source.includes('Data([]) // hairwrap-key-material')) throw new Error('Key already initialized')
  const bytes = Buffer.from(randomBytes(36).toString('base64url')) // 48-character random passphrase
  source = source.replace('Data([]) // hairwrap-key-material', `Data([${[...bytes].join(', ')}]) // hairwrap-key-material`)
  await writeFile(swift, source)
}
const match = source.match(/Data\(\[([\d,\s]+)\]\)\s*\/\/ hairwrap-key-material/)
if (!match) throw new Error('Missing bundled key material')
const material = Buffer.from(match[1].split(',').map(Number))
if (material.length < 24) throw new Error('Key must exceed 23 characters')
const digest = (bytes) => createHash('sha256').update(bytes).digest('hex')
const key = (layer) => createHash('sha256').update(material).update(Buffer.from([layer])).digest()
function seal(bytes, layer) {
  const size = Buffer.alloc(8)
  size.writeBigUInt64BE(BigInt(bytes.length))
  const nonce = randomBytes(12)
  const cipher = createCipheriv('aes-256-gcm', key(layer), nonce)
  const ciphertext = Buffer.concat([cipher.update(Buffer.concat([size, deflateSync(bytes, { level: 9 })])), cipher.final()])
  return Buffer.concat([nonce, ciphertext, cipher.getAuthTag()])
}
function open(bytes, layer) {
  const cipher = createDecipheriv('aes-256-gcm', key(layer), bytes.subarray(0, 12))
  cipher.setAuthTag(bytes.subarray(-16))
  const data = Buffer.concat([cipher.update(bytes.subarray(12, -16)), cipher.final()])
  const length = Number(data.readBigUInt64BE())
  if (length <= 0 || length > 64 * 1024 * 1024) throw new Error('Invalid archive length')
  const result = inflateSync(data.subarray(8), { maxOutputLength: length })
  if (result.length !== length) throw new Error('Invalid archive size')
  return result
}
const files = []
async function visit(directory) {
  for (const entry of (await readdir(directory)).sort()) {
    const absolute = path.join(directory, entry)
    const stat = await lstat(absolute)
    if (stat.isSymbolicLink()) throw new Error('Symbolic links are not allowed')
    if (stat.isDirectory()) await visit(absolute)
    else if (stat.isFile()) {
      const relative = path.relative(input, absolute).split(path.sep).join('/')
      if (relative.split('/').some((part) => !part || part === '.' || part === '..') || relative.includes('\\')) throw new Error('Unsafe path')
      const bytes = await readFile(absolute)
      files.push({ path: relative, digest: digest(bytes), bytes: bytes.toString('base64') })
    } else throw new Error('Unsupported archive entry')
  }
}
await visit(input)
if (!files.some((file) => file.path === 'index.html') || !files.some((file) => file.path === 'config/app-config.js')) throw new Error('Incomplete H5 input')
const plaintext = Buffer.from(JSON.stringify({ version: 1, files }))
if (plaintext.length > 64 * 1024 * 1024 || files.length > 2000) throw new Error('Archive exceeds runtime limits')
let existing
try { existing = await readFile(output) } catch {}
if (args.includes('--verify')) {
  if (!existing || !open(open(existing, 2), 1).equals(plaintext)) throw new Error('Archive differs from H5 input')
  console.log(`Verified ${files.length} files, two compression/encryption layers, ${material.length}-character key; archive sha256=${digest(existing)}`)
} else {
  let unchanged = false
  try { unchanged = existing && open(open(existing, 2), 1).equals(plaintext) } catch {}
  if (!unchanged) {
    const packed = seal(seal(plaintext, 1), 2)
    if (!open(open(packed, 2), 1).equals(plaintext)) throw new Error('Round-trip validation failed')
    await mkdir(path.dirname(output), { recursive: true })
    await writeFile(output, packed)
  }
  console.log(`Packed ${files.length} unchanged H5 files into CoastalWeave.dat; key not logged.`)
}
