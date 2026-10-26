#!/usr/bin/env python3
import csv
import hashlib
import json
import random
import re
from collections import defaultdict
from pathlib import Path

out=Path('reports/naming-migration');out.mkdir(parents=True,exist_ok=True)
old=json.loads(Path('reports/original-names/inventory.json').read_text())
new=json.loads(Path('reports/current-names-before/inventory.json').read_text())
root=Path(new['source'])
snapshot=out/'before-source'
read_root=snapshot.resolve() if snapshot.exists() else root
pool={r['base_name'] for r in old['declarations']}
current={r['base_name'] for r in new['declarations'] if r['classification'] not in
         {'extension_target_not_new_type', 'language_defined_base_name'}}
index=json.loads((out/'baseline-index.json').read_text())
def project(usr):return '10JOiySuizoy' in usr or '@M@JOiySuizoy' in usr
def labels(name):return [x for x in name.split('(',1)[-1].rstrip(')').split(':') if x and x!='_'] if '(' in name else []
protected=set()
protected_offsets=defaultdict(list)
external_call_offsets=defaultdict(list)
project_positions={(r['file'],r['line'],r['column']) for r in index if project(r['usr'])}
required_usrs={r['usr'] for r in index if r['roles']&3 and project(r['usr']) and not r['name'].startswith(('init(', 'deinit')) and
               any((rel['roles']&(2048|1024)) and not project(rel['usr']) for rel in r['relations'])}
for r in index:
    if not project(r['usr']) and '(' in r['name']:
        external_call_offsets[r['file']].append([r['line'],r['column']])
    if not project(r['usr']) and (r['file'],r['line'],r['column']) not in project_positions:
        protected_offsets[r['file']].append([r['line'],r['column']])
    if r['usr'] in required_usrs:
        protected_offsets[r['file']].append([r['line'],r['column']])
    if r['roles']&3 and project(r['usr']):
        if any((rel['roles'] & (2048|1024)) and not project(rel['usr']) for rel in r['relations']):
            protected.add(r['name'].split('(')[0]);protected.update(labels(r['name']))
protected.update({'init','deinit','subscript','stringValue','intValue','rawValue',
                  'CodingKeys','encode','hash','hashValue','description','errorDescription'})
types={'class','struct','enum'}
files_by_name=defaultdict(set)
texts={}
for path in read_root.rglob('*.swift'):
    rel=str(path.relative_to(read_root));text=path.read_text();texts[rel]=text
    # Includes strings too: conservative avoidance of candidate collisions.
    for word in set(re.findall(r'\b[A-Za-z_][A-Za-z_0-9]*\b',text)):
        files_by_name[word].add(rel)
targets=sorted(n for n in current-pool if n not in {'init','deinit','subscript','CodingKeys'} and re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*',n))
reserved=set('actor any as associatedtype async await borrowing break case catch class consuming continue convenience copy default defer deinit didSet distributed do dynamic each else enum extension fallthrough false fileprivate final for func get guard if import in indirect infix init inout internal is isolated lazy let macro mutating nil nonisolated nonmutating open operator optional override package postfix precedencegroup prefix private protocol public repeat required rethrows return self Self sending set some static struct subscript super switch throw throws true try typealias unowned var weak where while willSet'.split())
top_types={r['name'] for r in new['declarations'] if r['kind'] in types and not r['owner']}
all_type_targets={r['name'] for r in new['declarations'] if r['kind'] in types}-pool
external_names={r['name'].split('(')[0] for r in index if not project(r['usr'])}
extension_targets={r['name'] for r in old['declarations'] if r['kind']=='extension'}
candidates=sorted(n for n in pool if re.fullmatch(r'[A-Za-z][A-Za-z_0-9]*',n) and len(n)>=4 and n not in reserved and n not in top_types and n not in protected and n not in external_names and n not in extension_targets)
rng=random.Random(20261026)
choices={}
for n in targets:
    c=[p for p in candidates if not(files_by_name[p] & files_by_name[n])]
    if n in all_type_targets:
        # New types get names absent from every current source, eliminating shadowing.
        c=[p for p in c if p not in current]
    rng.shuffle(c);choices[n]=c
assignment={};taken={}
def assign(n,seen):
    for candidate in choices[n]:
        if candidate in seen:continue
        seen.add(candidate)
        prior=taken.get(candidate)
        if prior is None or assign(prior,seen):
            taken[candidate]=n;assignment[n]=candidate;return True
    return False
for n in sorted(targets,key=lambda n:len(choices[n])):
    if not assign(n,set()):raise RuntimeError(f'No collision-free legacy name for {n}; candidates={len(choices[n])}')
rows=[]
for kind in sorted(types):
    prior={r['name'] for r in old['declarations'] if r['kind']==kind}
    now={r['name'] for r in new['declarations'] if r['kind']==kind}
    for name in sorted(prior|now):
        rows.append(dict(kind=kind,name=name,status='retained' if name in prior&now else 'added' if name in now else 'removed',replacement=assignment.get(name,'')))
with (out/'type_comparison.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['kind','name','status','replacement']);w.writeheader();w.writerows(rows)
with (out/'rename_mapping.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f);w.writerow(['current_name','legacy_name','current_files','type_name'])
    for a,b in sorted(assignment.items()):w.writerow([a,b,';'.join(sorted(files_by_name[a])),a in all_type_targets])
plan=dict(mapping=assignment,protected_offsets=protected_offsets,external_call_offsets=external_call_offsets,protected_names=sorted(protected),
          seed=20261026,source=str(snapshot.resolve()),target_source=str(root),before_hashes={p:hashlib.sha256(t.encode()).hexdigest() for p,t in texts.items()})
(out/'rename-plan.json').write_text(json.dumps(plan,indent=2))
snapshot.mkdir(exist_ok=True)
for rel,text in texts.items():
    p=snapshot/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text)
print('Planned replacements:',len(assignment),'type identifiers:',len(all_type_targets),'protected new system names:',sorted(protected-pool))
print('Candidate choices min:',min(map(len,choices.values())))
