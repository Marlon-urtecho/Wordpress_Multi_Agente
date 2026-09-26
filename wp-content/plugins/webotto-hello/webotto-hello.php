<?php
/**
 * Plugin Name: Webotto Hello
 * Description: Adds the [webotto_hello] shortcode.
 * Version: 1.0.0
 * Author: Webotto
 * Text Domain: webotto-hello
 */

if (! defined('ABSPATH')) {
    exit;
}

/**
 * Render the Webotto Hello shortcode.
 *
 * @return string
 */
function webotto_hello_shortcode(): string
{
    return esc_html('Hola desde Webotto');
}

add_shortcode('webotto_hello', 'webotto_hello_shortcode');
