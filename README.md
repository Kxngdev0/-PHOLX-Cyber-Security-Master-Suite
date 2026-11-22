# -PHOLX-Cyber-Security-Master-Suite
ชุดเครื่องมืออัตโนมัติสำหรับงานด้านความปลอดภัยทางไซเบอร์ (Cybersecurity) บนระบบปฏิบัติการ Linux และ macOS พัฒนาด้วย Bash Script โดยแบ่งการทำงานออกเป็นโมดูลหลักเพื่อรองรับทั้งงานเฝ้าระวังระบบ (SOC) และงานประเมินช่องโหว่/ทดสอบเจาะระบบ (VAPT) พร้อมระบบส่งออกรายงานตรวจสอบมาตรฐาน

⚠️ Disclaimer: เครื่องมือนี้พัฒนาขึ้นเพื่อใช้ในการตรวจสอบความปลอดภัยภายในองค์กร การศึกษา และการทดสอบเจาะระบบที่ได้รับอนุญาตอย่างถูกต้องตามกฎหมายเท่านั้น ผู้พัฒนาไม่รับผิดชอบต่อความเสียหายใดๆ ที่เกิดจากการนำไปใช้งานในทางที่ผิด

📁 โครงสร้างไฟล์ในโปรเจกต์ (Project Structure)

pholx-cyber-suite/
├── menu.sh        # Main Switchboard: หน้าต่างควบคุมหลักสำหรับสลับโมดูล
├── soc_toot.sh    # SOC Module: เครื่องมือเฝ้าระวัง ตรวจสอบ และรับมือเหตุฉุกเฉิน
├── soc_vapt.sh    # VAPT Module: เครื่องมือสแกนช่องโหว่และเก็บหลักฐานการตรวจสอบ
└── README.md      # เอกสารแนะนำการใช้งาน


✨ ความสามารถหลัก (Key Features)

1. 🎛️ Main Switchboard (menu.sh)

หน้าเมนูหลักสำหรับควบคุมและสลับการใช้งานระหว่างโมดูล SOC และ VAPT

ทำงานแบบวนลูปต่อเนื่อง ช่วยให้กลับมายังหน้าหลักได้ทันทีหลังจากจบการทำงานในแต่ละโมดูล

2. 🚨 SOC Module (soc_toot.sh)

ออกแบบมาเพื่อการเฝ้าระวัง (Monitoring) และรับมือเหตุการณ์เบื้องต้น (Incident Response):

Dependency Auto-Check: ตรวจสอบความพร้อมของโปรแกรมที่จำเป็น (figlet, nmap) พร้อมแนะนำคำสั่งติดตั้งอัตโนมัติตามระบบปฏิบัติการ (macOS / Debian / Ubuntu)

Network Connections: ตรวจสอบพอร์ตที่เปิดรับการเชื่อมต่อและโปรเซสที่เกี่ยวข้อง (ss / netstat)

Failed SSH Logins: ตรวจสอบประวัติการพยายามล็อกอิน SSH ที่ล้มเหลว (log show บน macOS หรือ /var/log/auth.log, /var/log/secure บน Linux)

System Services: แสดงรายการเซอร์วิสที่กำลังทำงานอยู่ (systemctl / launchctl)

Incident Response (Kill Process): ยุติการทำงานของโปรเซสต้องสงสัยผ่านหมายเลข PID

Expanded Nmap Scanner: เมนูสแกนเครือข่าย 6 รูปแบบ (Quick Scan, Ping Sweep, Deep Aggressive Scan, Vulnerability Scan, Full 65,535 Ports Scan และ UDP Scan)

Report Export: บันทึกผลลัพธ์การตรวจสอบลงไฟล์ .txt พร้อมหัวกระดาษมาตรฐาน

3. 🔍 VAPT Module (soc_vapt.sh)

ออกแบบมาเพื่อการประเมินช่องโหว่และจัดเก็บหลักฐานการตรวจสอบ (Audit Evidence):

Automated VA: สแกนหาช่องโหว่และรหัส CVE ของเป้าหมายด้วย nmap --script vuln

Web PT (Directory Recon): จำลองการค้นหาไดเรกทอรีลับบนเว็บแอปพลิเคชัน

Service PT (Banner Grabbing): ดึงข้อมูลเวอร์ชันและ Banner จากพอร์ตบริการหลัก (21, 22, 80, 443)

Local Privilege Escalation Check: ตรวจสอบข้อมูล Kernel และสิทธิ์ผู้ใช้งานปัจจุบันเพื่อประเมินความเสี่ยงภายในเครื่อง

Evidence Management: สร้างโฟลเดอร์เก็บหลักฐานดิบตามวัน-เวลาอัตโนมัติ (pholx_vapt_evidence_YYYYMMDD_HHMMSS) และรองรับการตั้งชื่อไฟล์รายงานเองก่อนบันทึก

⚙️ ความต้องการของระบบ (Prerequisites)

ระบบปฏิบัติการ Linux (Ubuntu, Debian, Kali ฯลฯ) หรือ macOS

Bash Shell (bash)

โปรแกรมเสริมที่จำเป็น:

nmap (สำหรับฟีเจอร์สแกนเครือข่ายและช่องโหว่)

figlet (สำหรับแสดงแบนเนอร์ ASCII Art)

การติดตั้งโปรแกรมเสริม

สำหรับ Ubuntu / Debian:

sudo apt update && sudo apt install -y nmap figlet


สำหรับ macOS (ผ่าน Homebrew):

brew install nmap figlet


🚀 การติดตั้งและเริ่มต้นใช้งาน (Installation & Usage)

โคลนโปรเจกต์ลงเครื่อง:

git clone https://github.com/YOUR_USERNAME/pholx-cyber-suite.git
cd pholx-cyber-suite


กำหนดสิทธิ์ให้ไฟล์สคริปต์สามารถรันได้ (Executable):

chmod +x menu.sh soc_toot.sh soc_vapt.sh


ตรวจสอบ Path ในไฟล์ menu.sh:
หากวางไฟล์ทั้งหมดไว้ในโฟลเดอร์เดียวกัน แนะนำให้แก้ไขคำสั่งเรียกสคริปต์ใน menu.sh ให้ชี้ไปที่ตำแหน่งไฟล์จริง (เช่น ./soc_toot.sh และ ./soc_vapt.sh)

เริ่มต้นใช้งานโปรแกรม:

./menu.sh


(หมายเหตุ: ฟีเจอร์บางส่วนเช่นการสแกน UDP, การสแกน -A, การอ่าน Auth Log หรือการหยุดโปรเซสของระบบ จำเป็นต้องรันด้วยสิทธิ์ sudo)

📞 ติดต่อและสนับสนุน (Contact)

พัฒนาโดย PHOLX.CO.,LTD

Website: www.pholx.co.th

Email: chnanphon05@gmail.com

24/7 Incident Hotline: 061-679-3448
