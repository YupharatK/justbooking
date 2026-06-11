const fs = require('fs');
let file = 'lib/users/dorm_detail_page.dart';
let content = fs.readFileSync(file, 'utf8');

// The bottom navigation bar has `items: const [` which makes the items constants.
content = content.replace('items: const [', 'items: [');

// Line 1205 might be a const text or const TextSpan
content = content.replace("const Text(\n                        context.l10n.dormDetailCurrencyPerMonth,", "Text(\n                        context.l10n.dormDetailCurrencyPerMonth,");

fs.writeFileSync(file, content);
console.log('Fixed constants');
