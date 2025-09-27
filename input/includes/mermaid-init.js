// Mermaid initialization for inlined usage via Jekyll include
(function(){
  function initMermaid(){
    if (window.mermaid && typeof window.mermaid.initialize === 'function') {
      try {
        window.mermaid.initialize({ startOnLoad: true, securityLevel: 'loose' });
      } catch (e) {
        console && console.warn && console.warn('Mermaid init failed:', e);
      }
    }
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMermaid);
  } else {
    initMermaid();
  }
})();
