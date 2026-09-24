import { createGate } from './access-gate.mjs';

const message = document.querySelector('#access-message');
const retry = document.querySelector('#access-retry');
let sessionModule;
let sessionSnapshot;
let gate;
const conceal = () => {
  document.documentElement.classList.remove('access-approved');
  message.textContent = 'Comprovant el teu accés…';
  retry.hidden = true;
};
const unavailable = () => {
  message.textContent = 'No s’ha pogut comprovar la sessió. Revisa la connexió i torna-ho a provar.';
  retry.hidden = false;
};
async function initialize() {
  conceal();
  try {
    sessionModule = await import('/tmb-agent/src/session.js');
    gate = createGate({
      check: () => sessionModule.checkSession(),
      conceal,
      reveal: () => document.documentElement.classList.add('access-approved'),
      redirect: () => location.replace(sessionModule.loginUrl(location)),
      unavailable,
      start: () => {
        const script = document.createElement('script');
        script.src = 'flutter_bootstrap.js?v=train-camera-v1';
        script.async = true;
        script.onerror = () => { gate.suspend(); unavailable(); };
        document.body.append(script);
      },
    });
    sessionSnapshot = localStorage.getItem(sessionModule.SESSION_KEY);
    await gate.verify();
  } catch { unavailable(); }
}
retry.addEventListener('click', () => location.reload());
window.addEventListener('storage', event => {
  if (gate && (event.key === sessionModule.SESSION_KEY || event.key === null)) gate.verify();
});
window.addEventListener('pageshow', event => { if (event.persisted) gate?.verify(); });
window.addEventListener('pagehide', () => gate?.suspend());
document.addEventListener('visibilitychange', () => {
  if (document.hidden) gate?.suspend();
  else gate?.verify();
});
// Detect Flutter sign-out in this tab too; storage events only reach other tabs.
setInterval(() => {
  if (!gate || document.hidden) return;
  const current = localStorage.getItem(sessionModule.SESSION_KEY);
  if (current !== sessionSnapshot) { sessionSnapshot = current; gate.verify(); }
}, 1000);
setInterval(() => { if (!document.hidden) gate?.verify(); }, 60000);
initialize();
