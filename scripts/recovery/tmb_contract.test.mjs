import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
const source = await readFile('.integration-tmb/src/session.js', 'utf8');
const auth = await readFile('.integration-tmb/auth/lib/main.dart', 'utf8');
const {checkSession, SESSION_KEY, loginUrl} =
  await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));
const reply = (body,status=200) => ({ok:status===200,status,json:async()=>body});
const session = {access_token:'synthetic-token',expires_at:Math.floor(Date.now()/1000)+3600};
const storage = {getItem:key=>key===SESSION_KEY?JSON.stringify(session):null};
for (const state of ['aprobado','pendiente','rechazado']) {
  test('TMB session + L4 gate: '+state, async()=>{
    const {createGate}=await import('../../app/web/access-gate.mjs');
    let started=0,shown=0,redirected=0,requests=0;
    const gate=createGate({
      check:()=>checkSession(storage,async()=>reply(++requests===1?{id:'synthetic-user'}:[{estado:state}])),
      conceal(){}, reveal(){shown++;}, start(){started++;},
      redirect(){redirected++;}, unavailable(){assert.fail('unexpected error');}
    });
    await gate.verify();
    assert.equal(started,state==='aprobado'?1:0);
    assert.equal(shown,state==='aprobado'?1:0);
    assert.equal(redirected,state==='aprobado'?0:1);
  });
}
test('L4 return route fits current TMB auth allowlist; query and external paths excluded',()=>{
  assert.equal(loginUrl({pathname:'/incidencias-l4/',hash:'#/diagnostic'}),
    '/tmb-agent/auth/?returnTo=%2Fincidencias-l4%2F%23%2Fdiagnostic');
  assert.ok(auth.includes("['/tmb-agent/', '/incidencias-l4/']"));
  assert.ok(auth.includes('!requested.hasScheme'));
  assert.ok(auth.includes('!requested.hasAuthority'));
  assert.ok(auth.includes('!requested.hasQuery'));
});
test('expired or absent session does not request backend',async()=>{
  for (const value of [null,{...session,expires_at:1}])
    assert.equal(await checkSession({getItem:()=>JSON.stringify(value)},()=>assert.fail('network forbidden')), 'login');
});
test('offline fails closed and changing token cannot reuse approval',async()=>{
  await assert.rejects(checkSession(storage,async()=>{throw Error('offline');}));
  let value=JSON.stringify(session),count=0;
  assert.equal(await checkSession({getItem:()=>value},async()=>{
    if(++count===2)value=JSON.stringify({...session,access_token:'other-synthetic-token'});
    return reply(count===1?{id:'synthetic-user'}:[{estado:'aprobado'}]);
  }),'login');
});
