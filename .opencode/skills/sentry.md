# Sentry MCP Tool

## Overview
Use the official Sentry MCP server to query error monitoring and performance data from Sentry Cloud.

## MCP Server Configuration
The Sentry MCP server is configured in `~/.config/opencode/opencode.jsonc`:

\`\`\`jsonc
"sentry": {
  "type": "local",
  "command": ["npx", "-y", "@sentry/mcp-server"],
  "environment": {
    "SENTRY_AUTH_TOKEN": "{env:SENTRY_AUTH_TOKEN}",
  },
  "enabled": true,
  "timeout": 60000,
}
\`\`\`

## Prerequisites
- Environment variable \`SENTRY_AUTH_TOKEN\` must be set
- Token must have \`project:read\` scope for the target organization/project

## Available Tools

### search_issues
Search for Sentry issues with filters.

**Parameters:**
- \`organization\`: Organization slug (e.g., "gratheon")
- \`project\`: Project slug (e.g., "web-app")
- \`query\`: Search query (e.g., "is:unresolved firstSeen:-7d")
- \`sort\`: Sort field (e.g., "count", "date")
- \`limit\`: Maximum results (default: 10)

**Example:**
\`\`\`
Search for top 10 unresolved errors from last 7 days:
organization: gratheon
project: web-app
query: is:unresolved firstSeen:-7d
sort: count
desc: true
limit: 10
\`\`\`

### get_issue_details
Get detailed information about a specific issue.

**Parameters:**
- \`issue_id\`: The Sentry issue ID

### query_transactions
Query performance transactions.

**Parameters:**
- \`organization\`: Organization slug
- \`project\`: Project slug
- \`query\`: Transaction query (e.g., "event.type:transaction")
- \`fields\`: Fields to return (e.g., ["transaction", "transaction.duration.p95", "count()"])
- \`orderby\`: Sort order (e.g., "-transaction.duration.p95")
- \`limit\`: Maximum results

**Example:**
\`\`\`
Get top 10 slowest endpoints by P95:
organization: gratheon
project: web-app
query: event.type:transaction
fields: ["transaction", "transaction.duration.p95", "count()"]
orderby: -transaction.duration.p95
limit: 10
\`\`\`

### get_performance_summary
Get performance metrics summary for a project.

## Common Queries

### Weekly Error Digest
\`\`\`
Search issues with:
- organization: gratheon
- project: web-app
- query: is:unresolved firstSeen:-7d
- sort: count
- desc: true
- limit: 10
\`\`\`

### Slowest Endpoints (P95)
\`\`\`
Query transactions with:
- organization: gratheon
- project: web-app
- query: event.type:transaction
- fields: ["transaction", "transaction.duration.p95", "count()"]
- orderby: -transaction.duration.p95
- limit: 10
\`\`\`

## Output Formatting
When presenting results, format as:

**Errors:**
\`\`\`
🚨 Top {N} Errors (Last 7 Days)

1. [{title}] ({count} events, {userCount} users)
   🔗 {permalink}
\`\`\`

**Performance:**
\`\`\`
🐌 Top {N} Slowest Endpoints (P95)

1. \`{endpoint}\` (P95: {duration}, Count: {count})
\`\`\`

## Usage in Jobs
When running scheduled jobs (like the weekly Sentry digest):
1. Load environment: \`set -a && . ~/git/mind/.env && set +a\`
2. Use MCP tools to query Sentry data
3. Format results
4. Send to Discord via \`kimaki send\`

## Migration Notes
This replaces the custom TypeScript script previously located at:
`~/.opencode/tools/sentry-digest/`

The MCP approach provides:
- Pre-built, maintained tools
- No custom API code to maintain
- Richer functionality and better error handling
- Standardized interface across agents
