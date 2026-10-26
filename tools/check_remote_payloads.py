#!/usr/bin/env python3
"""Run standalone Foundation JSON encoding fixtures before/after the rename."""
import json
import subprocess
from pathlib import Path

report=Path('reports/remote-naming')
mapping=json.loads((report/'rename-plan.json').read_text())['mapping']
prior=json.loads(Path('reports/naming-migration/rename-plan.json').read_text())['mapping']
samples={
    'SuliJoyEmailPayload':[('email','String'),('password','String'),('deviceNo','String')],
    'SuliJoyRefreshPayload':[('refreshToken','String')],
    'SuliJoyProfilePayload':[('nickname','String'),('signature','String'),('icon','String')],
    'SuliJoyEmptyPayload':[],
    'SuliJoyUserIDPayload':[('userID','Int64')],
    'SuliJoyUserFollowPayload':[('followUserID','Int64'),('followType','Int')],
    'SuliJoyLetterListPayload':[('cursor','Int'),('limit','Int')],
    'SuliJoyLetterHistoryPayload':[('conversationId','String'),('cursor','Int'),('limit','Int')],
    'SuliJoyLetterSendPayload':[('conversationId','String'),('kind','String'),('text','String'),('clientMessageId','String')],
    'SuliJoyLetterReadPayload':[('conversationId','String')],
    'SuliJoyLetterOpenPayload':[('userId','String')],
    'SuliJoyUserBlockPayload':[('userID','Int64'),('type','Int')],
}
def declaration(source,name):
    start=source.index('private struct '+name+':')
    opening=source.index('{',start)
    depth=1; end=opening+1
    while depth:
        if source[end]=='{':depth+=1
        elif source[end]=='}':depth-=1
        end+=1
    return source[start:end]
outputs={}
for variant,filename in [('before',report/'before-source/SuliJoyLagoonRemoteClient.swift'),
                         ('after',Path('JOiySuizoy/JOiySuizoy/SuliJoyLagoonRemoteClient.swift'))]:
    source=filename.read_text()
    renamed=lambda x:mapping.get(prior.get(x,x),prior.get(x,x)) if variant=='after' else prior.get(x,x)
    pieces=['import Foundation']
    calls=[]
    for original,fields in samples.items():
        name=renamed(original)
        pieces.append(declaration(source,name))
        args=', '.join(renamed(n)+': '+('"fixture"' if t=='String' else '7') for n,t in fields)
        calls.append(f'let value{len(calls)} = try encoder.encode({name}({args}))\nprint("{original}:" + String(data: value{len(calls)}, encoding: .utf8)!)')
    pieces+=['let encoder = JSONEncoder()','encoder.outputFormatting = [.sortedKeys]']+calls
    fixture=report/f'payload-{variant}.swift'
    fixture.write_text('\n'.join(pieces)+'\n')
    executable=report/f'payload-{variant}'
    subprocess.run(['xcrun','swiftc','-module-cache-path','/private/tmp/sulijoy-naming-swift-cache',str(fixture),'-o',str(executable)],check=True,capture_output=True,text=True)
    result=subprocess.run([str(executable.resolve())],check=True,capture_output=True,text=True).stdout
    outputs[variant]=result
    (report/f'payload-{variant}.txt').write_text(result)
assert outputs['before']==outputs['after'],'Encoded request payload changed'
(report/'payload-fixture-result.json').write_text(json.dumps({'models_tested':list(samples),'encoded_output_identical':True},indent=2)+'\n')
print(f'PASS: {len(samples)} request models encode to identical JSON before/after renaming.')
