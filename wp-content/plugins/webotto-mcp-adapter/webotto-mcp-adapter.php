<?php
/**
 * Plugin Name: Webotto MCP Adapter
 * Description: Exposes a minimal authenticated MCP adapter endpoint for Webotto.
 * Version: 0.1.0
 * Author: Webotto
 * Text Domain: webotto-mcp-adapter
 */

if (! defined('ABSPATH')) {
    exit;
}

const WEBOTTO_MCP_NAMESPACE = 'mcp';
const WEBOTTO_MCP_ROUTE = '/mcp-adapter-default-server';

add_action('rest_api_init', 'webotto_mcp_register_routes');

/**
 * Register the Webotto MCP adapter route.
 *
 * The resulting endpoint is:
 * /wp-json/mcp/mcp-adapter-default-server
 */
function webotto_mcp_register_routes(): void
{
    register_rest_route(
        WEBOTTO_MCP_NAMESPACE,
        WEBOTTO_MCP_ROUTE,
        [
            'methods' => [WP_REST_Server::READABLE, WP_REST_Server::CREATABLE],
            'callback' => 'webotto_mcp_handle_request',
            'permission_callback' => 'webotto_mcp_can_access',
        ]
    );
}

/**
 * Restrict MCP access to authenticated site managers.
 *
 * @return bool
 */
function webotto_mcp_can_access(): bool
{
    return current_user_can('manage_options');
}

/**
 * Handle MCP discovery and minimal JSON-RPC requests.
 *
 * @param WP_REST_Request $request REST request.
 *
 * @return WP_REST_Response
 */
function webotto_mcp_handle_request(WP_REST_Request $request): WP_REST_Response
{
    if ($request->get_method() === 'GET') {
        return new WP_REST_Response(webotto_mcp_adapter_metadata(), 200);
    }

    $payload = $request->get_json_params();

    if (! is_array($payload)) {
        return new WP_REST_Response(
            webotto_mcp_json_rpc_error(null, -32700, 'Parse error'),
            400
        );
    }

    $method = isset($payload['method']) ? sanitize_text_field((string) $payload['method']) : '';
    $id = $payload['id'] ?? null;

    switch ($method) {
        case 'initialize':
            return new WP_REST_Response(
                [
                    'jsonrpc' => '2.0',
                    'id' => $id,
                    'result' => [
                        'protocolVersion' => '2024-11-05',
                        'serverInfo' => [
                            'name' => 'webotto-wordpress-mcp-adapter',
                            'version' => '0.1.0',
                        ],
                        'capabilities' => [
                            'tools' => [
                                'listChanged' => false,
                            ],
                        ],
                    ],
                ],
                200
            );

        case 'tools/list':
            return new WP_REST_Response(
                [
                    'jsonrpc' => '2.0',
                    'id' => $id,
                    'result' => [
                        'tools' => [],
                    ],
                ],
                200
            );

        default:
            return new WP_REST_Response(
                webotto_mcp_json_rpc_error($id, -32601, 'Method not found'),
                404
            );
    }
}

/**
 * Build adapter metadata for endpoint checks.
 *
 * @return array<string, mixed>
 */
function webotto_mcp_adapter_metadata(): array
{
    return [
        'name' => 'webotto-wordpress-mcp-adapter',
        'version' => '0.1.0',
        'endpoint' => rest_url(WEBOTTO_MCP_NAMESPACE . WEBOTTO_MCP_ROUTE),
        'authentication' => 'WordPress application password or authenticated REST request',
        'required_capability' => 'manage_options',
        'status' => 'available',
    ];
}

/**
 * Build a JSON-RPC error response.
 *
 * @param mixed  $id      JSON-RPC request ID.
 * @param int    $code    JSON-RPC error code.
 * @param string $message JSON-RPC error message.
 *
 * @return array<string, mixed>
 */
function webotto_mcp_json_rpc_error($id, int $code, string $message): array
{
    return [
        'jsonrpc' => '2.0',
        'id' => $id,
        'error' => [
            'code' => $code,
            'message' => $message,
        ],
    ];
}
