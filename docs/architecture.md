# Initial Architecture

User -> wordpress-orchestrator -> specialized agents -> validation -> WordPress/MCP

MCP adapter:
- WordPress plugin: `wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php`
- REST endpoint: `/wp-json/mcp/mcp-adapter-default-server`
- Access model: authenticated WordPress REST request with `manage_options`

Initial agents:
- wordpress-orchestrator
- wordpress-developer
- wordpress-security
- wordpress-qa

Model routing:
- Policy: `agents/model-policy.yml`
- wordpress-orchestrator: `reasoning`
- wordpress-developer: `coding`
- wordpress-security: `security`
- wordpress-qa: `testing`

The profiles are Gentle AI routing roles. The Gentle AI runtime must map each profile to a concrete model ID; this repository policy does not claim that a specific model is available.

Future agents:
- wordpress-seo
- wordpress-content
- wordpress-woocommerce
- wordpress-performance
