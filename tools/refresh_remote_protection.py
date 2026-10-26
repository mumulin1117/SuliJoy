import json
from pathlib import Path
from collections import defaultdict
p=Path('reports/remote-naming/rename-plan.json')
d=json.loads(p.read_text())
rows=json.loads(Path('reports/remote-naming/baseline-index.json').read_text())
inventory=json.loads(Path('reports/remote-naming/before-inventory/inventory.json').read_text())['declarations']
for r in inventory:
    if r['file']==d['target'] and r['kind']=='extension': d['mapping'].pop(r['base_name'],None)
def project(usr):return '10JOiySuizoy' in usr or '@M@JOiySuizoy' in usr
defined={r['usr'] for r in rows if r['file']==d['target'] and r['roles']&3 and project(r['usr'])}
required={r['usr'] for r in rows if r['usr'] in defined and r['roles']&3 and any(x['roles']&(1024|2048) and not project(x['usr']) for x in r['relations'])}
renameable={r['usr'] for r in rows if r['usr'] in defined-required and r['name'].split('(')[0] in d['mapping']}
rename_positions={(r['file'],r['line'],r['column']) for r in rows if r['usr'] in renameable}
protected=defaultdict(list);calls=defaultdict(list)
for r in rows:
    pos=(r['file'],r['line'],r['column'])
    if r['usr'] not in defined-required and pos not in rename_positions:
        protected[r['file']].append([r['line'],r['column']])
    if '(' in r['name'] and (r['usr'] not in defined or r['usr'] in required):
        calls[r['file']].append([r['line'],r['column']])
d['protected_offsets']=protected
d['external_call_offsets']=calls
d['target_calls'][d['target']]=[[r['line'],r['column']] for r in rows if r['file']==d['target'] and r['usr'] in defined-required and '(' in r['name']]
p.write_text(json.dumps(d,indent=2))
print('Updated precise scope protection;',len(d['mapping']),'legacy replacements')
