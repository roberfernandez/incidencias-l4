import test from 'node:test';
import assert from 'node:assert/strict';
import { createGate } from '../access-gate.mjs';

function setup(check) {
  const events = [];
  const gate = createGate(Object.fromEntries([
    ['check', check],
    ...['conceal', 'reveal', 'start', 'redirect', 'unavailable'].map(name => [name, () => events.push(name)]),
  ]));
  return { gate, events };
}
test('approved remotely: Flutter starts once, with no new login form', async () => {
  const { gate, events } = setup(async () => 'approved');
  await gate.verify(); await gate.verify();
  assert.deepEqual(events, ['conceal', 'start', 'reveal', 'conceal', 'reveal']);
});
for (const state of ['login', 'pendiente', 'rechazado', null]) {
  test(`unauthorized (${state}): redirect without loading Flutter`, async () => {
    const { gate, events } = setup(async () => state);
    await gate.verify();
    assert.deepEqual(events, ['conceal', 'redirect']);
  });
}
test('network failure fails closed with visible retry', async () => {
  const { gate, events } = setup(async () => { throw Error('offline'); });
  await gate.verify();
  assert.deepEqual(events, ['conceal', 'unavailable']);
});
test('late approval cannot reveal a suspended page', async () => {
  let finish;
  const { gate, events } = setup(() => new Promise(resolve => { finish = resolve; }));
  const pending = gate.verify(); gate.suspend(); finish('approved'); await pending;
  assert.deepEqual(events, ['conceal', 'conceal']);
});
test('session removal after entry conceals app and redirects', async () => {
  let state = 'approved';
  const { gate, events } = setup(async () => state);
  await gate.verify(); state = 'login'; await gate.verify();
  assert.deepEqual(events, ['conceal', 'start', 'reveal', 'conceal', 'redirect']);
});
