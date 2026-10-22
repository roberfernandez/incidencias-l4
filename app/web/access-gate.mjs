// Shares TMB Agent's existing Auth/approval check, without a second login.
export function createGate({ check, conceal, reveal, start, redirect, unavailable }) {
  let revision = 0;
  let started = false;
  function suspend() { ++revision; conceal(); }
  async function verify({ silent = false } = {}) {
    const current = ++revision;
    if (!silent || !started) conceal();
    try {
      const state = await check();
      if (current !== revision) return;
      if (state !== 'approved') { if (silent && started) conceal(); redirect(); return; }
      if (!started) { start(); started = true; }
      reveal();
    } catch {
      if (current === revision) { if (silent && started) conceal(); unavailable(); }
    }
  }
  return { verify, suspend };
}
