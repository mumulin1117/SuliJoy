import json, random, re, csv, hashlib
from pathlib import Path

target='SuliJoymetallicThreadController.swift'
out=Path('reports/metallic-naming');out.mkdir(exist_ok=True)
root=Path('JOiySuizoy/JOiySuizoy')
source=(root/target).read_text()
assert source==Path('reports/remote-naming/before-source',target).read_text(),'Refresh symbol inventory before renaming changed source'
inventory=json.loads(Path('reports/remote-naming/after-inventory/inventory.json').read_text())['declarations']
old=json.loads(Path('reports/original-names/inventory.json').read_text())['declarations']
index=json.loads(Path('reports/remote-naming/baseline-index.json').read_text())
rows=[r for r in inventory if r['file']==target]
fixed={r['base_name'] for r in rows if r['kind']=='class' or r['is_override']}
fixed.update({'viewDidLoad','viewWillAppear','viewWillDisappear'})
names={r['base_name'] for r in rows}-fixed
tokens=set(re.findall(r'\b[A-Za-z_][A-Za-z_0-9]*\b',source))
def project(usr):return '10JOiySuizoy' in usr or '@M@JOiySuizoy' in usr
external={r['name'].split('(')[0] for r in index if not project(r['usr'])}
types={r['base_name'] for r in inventory if r['kind'] in {'class','struct','enum'}}
candidates=sorted({r['base_name'] for r in old}-tokens-external-types)
candidates=[n for n in candidates if len(n)>=16 and re.fullmatch('[A-Za-z][A-Za-z_0-9]*',n)]
random.Random(20261028).shuffle(candidates)
mapping=dict(zip(sorted(names),candidates))
assert len(mapping)==len(names)
defined={r['usr'] for r in index if r['file']==target and r['roles']&3 and project(r['usr'])}
required={r['usr'] for r in index if r['usr'] in defined and r['roles']&3 and any(x['roles']&(1024|2048) and not project(x['usr']) for x in r['relations'])}
positions={(r['line'],r['column']) for r in index if r['file']==target and r['usr'] in defined-required}
protected=[];external_calls=[];local_calls=[]
for r in index:
    if r['file']!=target:continue
    pos=[r['line'],r['column']]
    if r['usr'] not in defined-required and tuple(pos) not in positions:protected.append(pos)
    if '(' in r['name']:
        (local_calls if r['usr'] in defined-required else external_calls).append(pos)
snapshot=out/'before-source';snapshot.mkdir(exist_ok=True)
assert not (snapshot/target).exists(),'Do not overwrite audit baseline'
(snapshot/target).write_text(source)
plan=dict(mapping=mapping,source=str(snapshot.resolve()),target=target,protected_offsets={target:protected},external_call_offsets={target:external_calls},references={},target_calls={target:local_calls},fixed_names=sorted(fixed),before_sha256=hashlib.sha256(source.encode()).hexdigest())
(out/'rename-plan.json').write_text(json.dumps(plan,indent=2))
with (out/'mapping.csv').open('w',newline='',encoding='utf-8-sig') as f:
    w=csv.writer(f);w.writerow(['before','legacy_replacement']);w.writerows(sorted(mapping.items()))
print('Selected',len(mapping),'legacy names; class and lifecycle signatures preserved')
