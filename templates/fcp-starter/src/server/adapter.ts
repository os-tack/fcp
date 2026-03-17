/**
 * Domain adapter — the bridge between fcp-core and your domain model.
 *
 * Implements FcpAdapter from fcp-core. Each method handles a different
 * aspect of the server lifecycle.
 *
 * See fcp-drawio's adapter.ts or fcp-terraform's adapter.ts for
 * real-world examples.
 */

// import { FcpAdapter } from '@os-tack/fcp-core';

export class YourDomainAdapter /* implements FcpAdapter */ {
  // TODO: Implement the FcpAdapter interface
  //
  // Required methods:
  //   dispatch(op)       — Handle a parsed operation, mutate the model
  //   query(q)           — Handle read-only queries against the model
  //   session(action)    — Handle session lifecycle (new, save, undo, redo)
  //   serialize()        — Convert semantic model to target format (string/bytes)
  //   deserialize(input) — Parse target format back into semantic model
}
