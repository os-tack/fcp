/**
 * FCP Server entry point.
 *
 * Wires up the domain adapter with createFcpServer() from fcp-core.
 */

import { createFcpServer } from '@os-tack/fcp-core';
import { YourDomainAdapter } from './adapter.js';
import { VERBS } from './verb-registry.js';
import { REFERENCE_CARD } from './reference-card.js';

const adapter = new YourDomainAdapter();

const mcp = createFcpServer({
  name: 'fcp-yourdomain',
  domain: 'yourdomain',       // Tool prefix: yourdomain(), yourdomain_query(), etc.
  adapter,
  verbs: VERBS,
  referenceCard: REFERENCE_CARD,
});

// TODO: Start the server
// mcp.run();
