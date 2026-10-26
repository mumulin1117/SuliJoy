import { readFile, writeFile, mkdtemp } from 'node:fs/promises'
import { createCipheriv, createHash, randomBytes } from 'node:crypto'
import { deflateSync } from 'node:zlib'
import { spawnSync } from 'node:child_process'
import path from 'node:path'
import os from 'node:os'

const root = path.resolve('JOiySuizoy/JOiySuizoy')
const swift = await readFile(path.join(root, 'HairwrapKnotDrape.swift'), 'utf8')
const material = Buffer.from(swift.match(/Data\(\[([\d,\s]+)\]\)\s*\/\/ hairwrap-key-material/)[1].split(',').map(Number))
const temporary = await mkdtemp(path.join(os.tmpdir(), 'sulijoy-hairwrap-'))
const archive = path.join(root, 'HairwrapKnotDrape/CoastalWeave.dat')
const tampered = Buffer.from(await readFile(archive))
tampered[tampered.length - 1] ^= 1
await writeFile(path.join(temporary, 'tampered.dat'), tampered)
function seal(bytes, layer, declaredSize = bytes.length) {
  const size = Buffer.alloc(8); size.writeBigUInt64BE(BigInt(declaredSize))
  const key = createHash('sha256').update(material).update(Buffer.from([layer])).digest()
  const nonce = randomBytes(12), cipher = createCipheriv('aes-256-gcm', key, nonce)
  return Buffer.concat([nonce, cipher.update(Buffer.concat([size, deflateSync(bytes)])), cipher.final(), cipher.getAuthTag()])
}
const bytes = Buffer.from('fixture'), digest = createHash('sha256').update(bytes).digest('hex')
const traversal = Buffer.from(JSON.stringify({ version: 1, files: [{ path: '../outside', bytes: bytes.toString('base64'), digest }] }))
await writeFile(path.join(temporary, 'traversal.dat'), seal(seal(traversal, 1), 2))
await writeFile(path.join(temporary, 'oversized.dat'), seal(bytes, 2, 128 * 1024 * 1024))
function run(command, args) {
  const result = spawnSync(command, args, { encoding: 'utf8' })
  if (result.status !== 0) throw new Error(result.stderr || result.stdout || `Exit ${result.status}`)
  if (result.stdout) console.log(result.stdout.trim())
}
const executable = path.join(temporary, 'verify')
run('xcrun', ['swiftc', '-module-cache-path', '/private/tmp/sulijoy-naming-swift-cache', path.join(root, 'SuliJoyPalmGlyphWeaver.swift'), path.join(root, 'HairwrapKnotDrape.swift'), 'tools/VerifyHairwrap.swift', '-o', executable])
run(executable, [archive, path.resolve('room-shell-h5/HairwrapKnotDrape'), temporary])
console.log('No key, token, or H5 plaintext was logged. Fixtures remain outside the App target.')
