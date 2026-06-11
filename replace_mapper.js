const fs = require('fs');
let file = 'lib/users/dorm_detail_page.dart';
let content = fs.readFileSync(file, 'utf8');

// Import the mapper
const importStr = "import '../core/localization/mapper.dart';";
if (!content.includes(importStr)) {
  content = content.replace("import '../core/localization/localization_extension.dart';", "import '../core/localization/localization_extension.dart';\nimport '../core/localization/mapper.dart';");
}

// Map the facility label in dorm_detail_page
// 1. In Room Types Section list of facilities
// Before: room.facilities.isNotEmpty ? room.facilities.join(', ') : context.l10n.dormDetailNoData
// We should map each facility first: room.facilities.map((f) => DataMapper.getFacilityName(context, f)).join(', ')
content = content.replace(
  "room.facilities.isNotEmpty ? room.facilities.join(', ') : context.l10n.dormDetailNoData",
  "room.facilities.isNotEmpty ? room.facilities.map((f) => DataMapper.getFacilityName(context, f)).join(', ') : context.l10n.dormDetailNoData"
);

// 2. In Amenities GridView
// Before: return _buildAmenityItem(Icons.check_circle_outline_rounded, dorm.facilities[index]);
// We should map the label
content = content.replace(
  "return _buildAmenityItem(Icons.check_circle_outline_rounded, dorm.facilities[index]);",
  "return _buildAmenityItem(Icons.check_circle_outline_rounded, DataMapper.getFacilityName(context, dorm.facilities[index]));"
);

fs.writeFileSync(file, content);
console.log('Mapper applied');
