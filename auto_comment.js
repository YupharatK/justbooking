const fs = require('fs');
const path = require('path');

const dir = 'lib/users/';
const files = [
  'home_page.dart',
  'search_page.dart',
  'dorm_detail_page.dart',
  'room_types_page.dart',
  'message_page.dart',
  'profile_page.dart',
  'edit_profile_page.dart',
  'favorites_page.dart',
  'language_page.dart',
  'payment_section_widget.dart'
];

// Reusable comment injection rules based on regex
const rules = [
  {
    match: /(@override\s+Widget build\(BuildContext context\) {)/g,
    comment: '// ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้'
  },
  {
    match: /(void initState\(\) {)/g,
    comment: '// ฟังก์ชัน initState จะถูกเรียกใช้งานเป็นสิ่งแรกสุดเมื่อเปิดหน้านี้ขึ้นมา (มักใช้สำหรับดึงข้อมูลเตรียมไว้)'
  },
  {
    match: /(ListView\.builder\()/g,
    comment: '// ใช้ ListView.builder สำหรับสร้างรายการข้อมูลแบบเลื่อนได้ (Scrollable List) ซึ่งจะวาด UI ตามจำนวนข้อมูลที่มี'
  },
  {
    match: /(StreamBuilder<)/g,
    comment: '// StreamBuilder ใช้สำหรับรอรับข้อมูลแบบ Real-time ถ้ามีข้อมูลส่งมาใหม่ หน้าจอจะถูกอัปเดตอัตโนมัติโดยไม่ต้องกดรีเฟรช'
  },
  {
    match: /(FutureBuilder<)/g,
    comment: '// FutureBuilder ใช้สำหรับรอให้ข้อมูลแบบ Asynchronous (เช่น การดึง API) ทำงานเสร็จก่อนถึงจะวาดหน้าจอ'
  },
  {
    match: /(setState\(\(\) {)/g,
    comment: '// คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป'
  },
  {
    match: /(Navigator\.push\()/g,
    comment: '// คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่'
  },
  {
    match: /(ScaffoldMessenger\.of\(context\)\.showSnackBar\()/g,
    comment: '// แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)'
  },
  {
    match: /(TextFormField\()/g,
    comment: '// กล่องรับข้อความ (TextField) สำหรับให้ผู้ใช้พิมพ์กรอกข้อมูล'
  },
  {
    match: /(ElevatedButton\()/g,
    comment: '// ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed'
  },
  {
    match: /(GestureDetector\()/g,
    comment: '// GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้'
  }
];

files.forEach(file => {
  const filePath = path.join(dir, file);
  if (!fs.existsSync(filePath)) return;
  
  let content = fs.readFileSync(filePath, 'utf8');
  let changed = false;

  rules.forEach(rule => {
    // We want to make sure we don't insert duplicate comments
    const tempContent = content.replace(rule.match, (matched, p1, offset, string) => {
      // Check if the comment already exists right before the match
      const precedingText = string.substring(Math.max(0, offset - 200), offset);
      if (precedingText.includes(rule.comment)) {
        return matched; // skip
      }
      
      // Determine the indentation of the matched line
      const lineStart = string.lastIndexOf('\n', offset) + 1;
      const indentMatch = string.substring(lineStart, offset).match(/^\s*/);
      const indent = indentMatch ? indentMatch[0] : '';
      
      changed = true;
      return `${indent}${rule.comment}\n${matched}`;
    });
    content = tempContent;
  });
  
  // Specific API comments based on function names for these remaining files
  const funcRegex = /Future<void> (_[a-zA-Z0-9_]+)\(/g;
  content = content.replace(funcRegex, (matched, funcName, offset, string) => {
    const precedingText = string.substring(Math.max(0, offset - 100), offset);
    if (precedingText.includes('// ฟังก์ชันแบบ Asynchronous สำหรับ')) return matched;
    
    changed = true;
    const lineStart = string.lastIndexOf('\n', offset) + 1;
    const indentMatch = string.substring(lineStart, offset).match(/^\s*/);
    const indent = indentMatch ? indentMatch[0] : '';
    return `${indent}// ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: ${funcName}\n${matched}`;
  });

  if (changed) {
    fs.writeFileSync(filePath, content);
    console.log(`Deep commented ${file}`);
  }
});
