import { readFile, writeFile, mkdtemp, rename } from 'node:fs/promises'
import { createDecipheriv } from 'node:crypto'
import { spawnSync } from 'node:child_process'
import path from 'node:path'
import os from 'node:os'

const root = path.resolve('JOiySuizoy/JOiySuizoy')
const swift = await readFile(path.join(root, 'SuliJoyOpiRegistry.swift'), 'utf8')
const key = Buffer.from(swift.match(/private static let [A-Za-z_][A-Za-z_0-9]* = SymmetricKey\(data: Data\(\[([\d,\s]+)\]\)\)/)[1].split(',').map(Number))
const resource = await readFile(path.join(root, 'SuliJoyOpiRegistry.json'))
const envelope = JSON.parse(resource)
const combined = Buffer.from(envelope.payload, 'base64')
const decipher = createDecipheriv('aes-256-gcm', key, combined.subarray(0, 12))
decipher.setAuthTag(combined.subarray(-16))
const plaintext = Buffer.concat([decipher.update(combined.subarray(12, -16)), decipher.final()])
const temporary = await mkdtemp(path.join(os.tmpdir(), 'sulijoy-registry-check-'))
const expected = path.join(temporary, 'expected.json')
const bundled = path.join(temporary, 'SuliJoyOpiRegistry.json')
const executable = path.join(temporary, 'registry-check')
await writeFile(expected, plaintext)
await writeFile(bundled, resource)
function run(command, args) {
  const result = spawnSync(command, args, { encoding: 'utf8' })
  if (result.status !== 0) throw new Error(result.stderr || result.stdout || `Exit ${result.status}`)
  if (result.stdout) console.log(result.stdout.trim())
}
run('xcrun', ['swiftc', '-module-cache-path', '/private/tmp/sulijoy-naming-swift-cache', path.join(root, 'SuliJoyPalmGlyphWeaver.swift'), path.join(root, 'SuliJoyOpiRegistry.swift'), 'tools/VerifyOpiRegistry.swift', '-o', executable])
run(executable, [expected])
combined[combined.length - 1] ^= 1
await writeFile(bundled, JSON.stringify({ version: 1, payload: combined.toString('base64') }))
run(executable, [expected, 'tampered'])
await rename(bundled, `${bundled}.invalid`)
run(executable, [expected, 'missing'])
console.log('Verification fixtures are outside the App target in a temporary directory.')
