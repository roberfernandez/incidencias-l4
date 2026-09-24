import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
import {createHash} from 'node:crypto';
const code=fs.readFileSync(new URL('../main.dart.js',import.meta.url),'utf8');
const block=code.slice(code.indexOf('A.Ia.prototype={')+'A.Ia.prototype='.length,code.indexOf('A.aCN.prototype='));
const type={i(){return type}};
function harness(file){
 const calls=[];const B={RF:{},RG:{},c:{dz:s=>s.trim(),k0:(s,x)=>s.endsWith(x)}};
 const A={z(){let resolve,reject;const promise=new Promise((a,b)=>{resolve=a;reject=b});return {resolve,reject,promise}},v:f=>f,y(f,r){f(0);return r.promise},n(p,f){Promise.resolve(p).then(x=>f(0,x),e=>f(1,e))},x(v,r){r.resolve(v)},w(e,r){r.reject(e)},QM:class{aap(...args){calls.push(['quality',...args])}},aCN:class{constructor(s,f){this.s=s;this.f=f}$0(){this.s.f=this.f}},aCO:class{constructor(s){this.s=s}$0(){this.s.r=true}},aCP:class{constructor(s){this.s=s}$0(){this.s.r=false}},cq(){return {m(){},G(){}}},and:x=>x,D6:x=>x,k:()=>type,j:x=>x,a2:a=>Object.fromEntries(Array.from({length:a.length/2},(_,i)=>[a[i*2],a[i*2+1]])),PK:class{constructor(upsert,mime){this.upsert=upsert;this.mime=mime}},dg:s=>({j:()=>s}),c9:()=>({iR:v=>calls.push(['saved',v])})};
 const storage={a:'https://example.invalid/storage',kR(name){calls.push(['bucket',name]);return this},Fr(path,bytes,options){calls.push(['upload',path,bytes,options]);return Promise.resolve()},Tf:path=>path};
 const table={a:{b:{},d:{}},zb(){return this},q5(){return this},adc(){return Promise.resolve(null)},Hd(row){calls.push(['insert',row]);return Promise.resolve()}};
 const backend={b:{ay:storage,kR:name=>{calls.push(['table',name]);return table}}};
 const $={aWs:()=>({ni(options,source){calls.push(['source',source]);return Promise.resolve(file)}}),cX:()=>backend};
 const state=Object.assign({a:{c:'S2100'},c:{},d:{a:{a:'TEST'}},e:{a:{a:''}},r:false,f:null,X(f){f.$0()}},vm.runInNewContext('('+block+')',{A,B,$,t:new Proxy({},{get:()=>type}),J:{bU:s=>s.length}}));
 return {state,calls,B};
}
for(const series of ['S2100','S9000'])for(const source of ['gallery','camera'])test(`${series}: ${source} uses existing image and train storage flow`,async()=>{
 const bytes=new Uint8Array([1,2,3]);const file={b:'fixture.png',NP:async()=>bytes};const {state,calls,B}=harness(file);state.a.c=series;
 await (source==='camera'?state.deaCamera():state.Ac());assert.equal(state.f,file);assert.equal(calls.find(x=>x[0]==='source')[1],source==='camera'?B.RF:B.RG);assert.equal(calls[0][1],95);
 await state.pk();const upload=calls.find(x=>x[0]==='upload');assert.equal(upload[1],'TEST.png');assert.equal(upload[2],bytes);assert.equal(upload[3].mime,'image/png');assert.equal(upload[3].upsert,false);
 const row=calls.find(x=>x[0]==='insert')[1];assert.equal(row.serie,series);assert.equal(row.numero,'TEST');assert.equal(row.imagen,'https://example.invalid/storage/object/public/TEST.png');assert.ok(calls.some(x=>x[0]==='saved'));assert.equal(state.r,false);
});
for(const source of ['gallery','camera'])test(`${source}: cancellation preserves previous image`,async()=>{const {state}=harness(null);const previous={};state.f=previous;await(source==='camera'?state.deaCamera():state.Ac());assert.equal(state.f,previous)});
test('saving implementation unchanged',()=>{const save=block.slice(block.indexOf('pk(){'),block.indexOf('M(a){'));assert.equal(createHash('sha256').update(save.replace(/\r\n/g,'\n')).digest('hex'),fs.readFileSync(new URL('./train-save.sha256',import.meta.url),'utf8'))});
test('web picker requests rear camera only for camera source',()=>{const start=code.indexOf('atp(a,b){if(a===B.RF)');const end=code.indexOf('afA(a){',start);const B={RF:{},RG:{},LS:{}};const picker=vm.runInNewContext('({'+code.slice(start,end)+'})',{B});assert.equal(picker.atp(B.RF,{}),'environment');assert.equal(picker.atp(B.RG,{}),null)});
