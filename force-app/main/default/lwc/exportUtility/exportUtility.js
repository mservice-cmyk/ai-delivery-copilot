/**
 * Utility class for exporting and copying AI-generated content
 * Browser-safe JavaScript only
 */

/**
 * Copy text to clipboard
 * @param {string} text - Text to copy
 * @returns {Promise<boolean>} - Success status
 */
export function copyToClipboard(text) {
    return new Promise((resolve) => {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.left = '-9999px';
        textarea.style.top = '-9999px';
        textarea.setAttribute('readonly', '');
        document.body.appendChild(textarea);

        try {
            textarea.select();
            textarea.setSelectionRange(0, textarea.value.length);
            const successful = document.execCommand('copy');
            document.body.removeChild(textarea);
            resolve(successful);
        } catch (err) {
            document.body.removeChild(textarea);
            resolve(false);
        }
    });
}

/**
 * Download content as a file
 * @param {string} content - File content
 * @param {string} filename - Name of the file
 * @param {string} mimeType - MIME type (default: text/plain)
 */
export function downloadFile(content, filename, mimeType = 'text/plain') {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
}

/**
 * Convert data to Markdown format
 * @param {Object} data - Data object to convert
 * @param {string} title - Document title
 * @returns {string} - Markdown formatted string
 */
export function convertToMarkdown(data, title) {
    let markdown = `# ${title}\n\n`;
    markdown += `Generated: ${new Date().toLocaleString()}\n\n---\n\n`;

    for (const [key, value] of Object.entries(data)) {
        markdown += formatMarkdownSection(key, value);
    }

    return markdown;
}

/**
 * Format a section for Markdown
 * @param {string} key - Section key
 * @param {*} value - Section value
 * @returns {string} - Formatted markdown section
 */
function formatMarkdownSection(key, value) {
    const sectionTitle = formatTitle(key);
    let markdown = `## ${sectionTitle}\n\n`;

    if (Array.isArray(value)) {
        value.forEach((item, index) => {
            if (typeof item === 'object') {
                markdown += formatObjectAsMarkdown(item, index + 1);
            } else {
                markdown += `- ${item}\n`;
            }
        });
    } else if (typeof value === 'object' && value !== null) {
        markdown += formatObjectAsMarkdown(value);
    } else {
        markdown += `${value}\n`;
    }

    markdown += '\n';
    return markdown;
}

/**
 * Format object as Markdown
 * @param {Object} obj - Object to format
 * @param {number} index - Optional index number
 * @returns {string} - Formatted markdown
 */
function formatObjectAsMarkdown(obj, index) {
    let markdown = '';

    if (index) {
        markdown += `### ${index}. `;
        if (obj.title || obj.name || obj.description) {
            markdown += `${obj.title || obj.name || obj.description}\n\n`;
        } else {
            markdown += '\n';
        }
    }

    for (const [key, value] of Object.entries(obj)) {
        if (key === 'id' || key === 'key') continue;

        const fieldName = formatTitle(key);

        if (Array.isArray(value)) {
            markdown += `**${fieldName}:**\n`;
            value.forEach(item => {
                if (typeof item === 'string') {
                    markdown += `- ${item}\n`;
                } else if (typeof item === 'object') {
                    markdown += `- ${JSON.stringify(item)}\n`;
                }
            });
        } else if (typeof value === 'object' && value !== null) {
            markdown += `**${fieldName}:** ${JSON.stringify(value)}\n`;
        } else {
            markdown += `**${fieldName}:** ${value}\n`;
        }
    }

    markdown += '\n';
    return markdown;
}

/**
 * Convert data to CSV format
 * @param {Array} data - Array of objects to convert
 * @param {Array} headers - Optional custom headers
 * @returns {string} - CSV formatted string
 */
export function convertToCSV(data, headers = null) {
    if (!Array.isArray(data) || data.length === 0) {
        return '';
    }

    const allHeaders = headers || Object.keys(data[0]).filter(key => key !== 'id');
    const csvHeaders = allHeaders.map(escapeCSVField).join(',');

    const csvRows = data.map(row => {
        return allHeaders.map(header => {
            let value = row[header];

            if (value === undefined || value === null) {
                return '';
            }

            if (typeof value === 'object') {
                value = JSON.stringify(value);
            }

            return escapeCSVField(String(value));
        }).join(',');
    });

    return [csvHeaders, ...csvRows].join('\n');
}

/**
 * Escape CSV field
 * @param {string} field - Field to escape
 * @returns {string} - Escaped field
 */
function escapeCSVField(field) {
    if (field.includes(',') || field.includes('"') || field.includes('\n')) {
        return `"${field.replace(/"/g, '""')}"`;
    }
    return field;
}

/**
 * Format title from camelCase or snake_case
 * @param {string} str - String to format
 * @returns {string} - Formatted title
 */
function formatTitle(str) {
    return str
        .replace(/([A-Z])/g, ' $1')
        .replace(/_/g, ' ')
        .replace(/^./, (match) => match.toUpperCase())
        .trim();
}

/**
 * Generate filename with timestamp
 * @param {string} prefix - Filename prefix
 * @param {string} extension - File extension (without dot)
 * @returns {string} - Filename with timestamp
 */
export function generateFilename(prefix, extension) {
    const timestamp = new Date().toISOString().slice(0, 19).replace(/:/g, '-');
    return `${prefix}_${timestamp}.${extension}`;
}
