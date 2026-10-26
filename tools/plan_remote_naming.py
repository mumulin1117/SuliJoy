import json, re, random, csv, hashlib
from pathlib import Path
from collections import defaultdict

out=Path('reports/remote-naming')
root=Path('JOiySuizoy/JOiySuizoy')
target='SuliJoyLagoonRemoteClient.swift'
inventory=json.loads((out/'before-inventory/inventory.json').read_text())['declarations']
old=json.loads(Path('reports/original-names/inventory.json').read_text())['declarations']
index=json.loads((out/'baseline-index.json').read_text())
pool={r['base_name'] for r in old}
rows=[r for r in inventory if r['file']==target]
names={r['base_name'] for r in rows}
names.update({'Payload','Body'})
def project(usr): return '10JOiySuizoy' in usr or '@M@JOiySuizoy' in usr
classes={r['base_name'] for r in inventory if r['kind']=='class'}
required={r['usr'] for r in index if r['file']==target and r['roles']&3 and project(r['usr']) and any(x['roles']&(1024|2048) and not project(x['usr']) for x in r['relations'])}
fixed={'init','deinit','subscript','CodingKeys','Key','from','stringValue','intValue','rawValue','errorDescription','description','encode','hash','hashValue'}|classes
names={n for n in names-fixed if re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*',n)}
texts={p.name:p.read_text() for p in root.glob('*.swift')}
tokens=set(re.findall(r'\b[A-Za-z_][A-Za-z_0-9]*\b',texts[target]))
toptypes={r['base_name'] for r in inventory if r['kind'] in {'class','struct','enum','protocol','typealias'} and not r['owner']}
external={r['name'].split('(')[0] for r in index if not project(r['usr'])}
reserved=set('actor any as async await borrowing break case catch class consuming continue convenience copy default defer deinit didSet distributed do dynamic each else enum extension fallthrough false fileprivate final for func get guard if import in indirect infix init inout internal is isolated lazy let macro mutating nil nonisolated nonmutating open operator optional override package postfix private protocol public repeat required rethrows return self Self sending set some static struct subscript super switch throw throws true try typealias unowned var weak where while willSet'.split())
candidates=sorted(n for n in pool-tokens-toptypes-external-fixed-reserved if re.fullmatch(r'[A-Za-z][A-Za-z_0-9]*',n) and len(n)>=12)
random.Random(20261027).shuffle(candidates)
assert len(candidates)>=len(names),(len(candidates),len(names))
mapping=dict(zip(sorted(names),candidates))
protected=defaultdict(list); calls=defaultdict(list)
project_positions={(r['file'],r['line'],r['column']) for r in index if project(r['usr'])}
target_usrs={r['usr'] for r in index if r['file']==target and r['roles']&3 and project(r['usr']) and r['usr'] not in required and (r['name'].split('(')[0] in mapping or r['name'].startswith('init('))}
references=defaultdict(dict); targetcalls=defaultdict(list)
for r in index:
    pos=[r['line'],r['column']]
    if not project(r['usr']) and (r['file'],*pos) not in project_positions or r['usr'] in required:
        protected[r['file']].append(pos)
    if not project(r['usr']) and '(' in r['name']: calls[r['file']].append(pos)
    if r['file']!=target and r['usr'] in target_usrs:
        n=r['name'].split('(')[0]
        if n in mapping: references[r['file']]['%s:%s'%tuple(pos)]=mapping[n]
        if '(' in r['name']: targetcalls[r['file']].append(pos)
plan=dict(mapping=mapping,source=str((out/'before-source').resolve()),target=target,protected_offsets=protected,external_call_offsets=calls,references=references,target_calls=targetcalls,fixed_names=sorted(fixed),before_hashes={p:hashlib.sha256(t.encode()).hexdigest() for p,t in texts.items()})
(out/'before-source').mkdir(exist_ok=True)
for p,t in texts.items():
    snap=out/'before-source'/p
    assert not snap.exists(),'Do not overwrite the baseline'
    snap.write_text(t)
(out/'rename-plan.json').write_text(json.dumps(plan,indent=2))
with (out/'mapping.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(['before','legacy_replacement']);w.writerows(sorted(mapping.items()))
print('Planned',len(mapping),'direct legacy names; references in',len(references),'other files; candidates',len(candidates))
