#!/usr/bin/env python3
import ctypes as C
import json
import sys
from pathlib import Path

LIB = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib'
class Ref(C.Structure):
    _fields_ = [('data', C.c_void_p), ('length', C.c_size_t)]
lib=C.CDLL(LIB)
def api(name, ret, *args):
    f=getattr(lib,'indexstore_'+name); f.restype=ret; f.argtypes=list(args); return f
P=C.c_void_p
create=api('store_create',P,C.c_char_p,C.POINTER(P))
reader=api('record_reader_create',P,P,C.c_char_p,C.POINTER(P))
dispose=api('record_reader_dispose',None,P)
occ_symbol=api('occurrence_get_symbol',P,P)
symbol_usr=api('symbol_get_usr',Ref,P)
symbol_name=api('symbol_get_name',Ref,P)
roles=api('occurrence_get_roles',C.c_uint64,P)
relation_symbol=api('symbol_relation_get_symbol',P,P)
relation_roles=api('symbol_relation_get_roles',C.c_uint64,P)
linecol=api('occurrence_get_line_col',None,P,C.POINTER(C.c_uint),C.POINTER(C.c_uint))
CB=C.CFUNCTYPE(C.c_bool,P,P)
apply=api('record_reader_occurrences_apply_f',C.c_bool,P,P,CB)
relations_apply=api('occurrence_relations_apply_f',C.c_bool,P,P,CB)
def string(ref): return C.string_at(ref.data,ref.length).decode() if ref.data else ''
storepath=Path(sys.argv[1] if len(sys.argv)>1 else 'build/NamingBaseline/Index.noindex/DataStore')
error=P(); store=create(str(storepath.resolve()).encode(),C.byref(error))
assert store,'index store not opened'
source=Path('JOiySuizoy/JOiySuizoy').resolve()
files={p.name:p for p in source.rglob('*.swift')}
records=[]
for path in sorted((storepath/'v5/records').rglob('*.swift-*')):
    basename=path.name.split('.swift-')[0]+'.swift'
    if basename not in files: continue
    rec=reader(store,path.name.encode(),C.byref(error))
    if not rec: continue
    @CB
    def callback(_,occ):
        symbol=occ_symbol(occ); line=C.c_uint();col=C.c_uint()
        linecol(occ,C.byref(line),C.byref(col))
        relations=[]
        @CB
        def relation_cb(_,rel):
            sym=relation_symbol(rel)
            relations.append(dict(name=string(symbol_name(sym)),usr=string(symbol_usr(sym)),roles=relation_roles(rel)))
            return True
        if roles(occ)&3: relations_apply(occ,None,relation_cb)
        records.append(dict(file=str(files[basename].relative_to(source)),line=line.value,
            column=col.value,name=string(symbol_name(symbol)),usr=string(symbol_usr(symbol)),roles=roles(occ),relations=relations))
        return True
    apply(rec,None,callback);dispose(rec)
out=Path(sys.argv[2] if len(sys.argv)>2 else 'reports/naming-migration');out.mkdir(parents=True,exist_ok=True)
(out/'baseline-index.json').write_text(json.dumps(records,indent=2))
print('Index occurrences:',len(records),'source files:',len(set(r['file'] for r in records)))
print('Project declarations:',sum(bool(r['roles']&3) and r['usr'].startswith('s:10JOiySuizoy') for r in records))
