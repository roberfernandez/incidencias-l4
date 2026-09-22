// Shares TMB Agent's existing Auth/approval check, without a second login.
export function createGate({ check, conceal, reveal, start, redirect, unavailable }) {
  let revision = 0;
  let started = false;
  function suspend() { ++revision; conceal(); }
  async function verify() {
    const current = ++revision;
    conceal();
    try {
      const state = await check();
      if (current !== revision) return;
      if (state !== 'approved') { redirect(); return; }
      if (!started) { start(); started = true; }
      reveal();
    } catch {
      if (current === revision) unavailable();
    }
  }
  return { verify, suspend };
}
