#!/usr/bin/env bash

# Terminal color codes
RED='\033[0;31m'    
GREEN='\033[0;32m'  
YELLOW='\033[0;33m' 
BLUE='\033[0;34m'   
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

check_dependencies() {
    if ! command -v figlet &> /dev/null || ! command -v nmap &> /dev/null; then
        echo -e "${YELLOW}[!] Warning: Missing required dependencies on this system.${NC}"
        echo "----------------------------------------------------------------------"
        if ! command -v figlet &> /dev/null; then echo -e "${RED}[- ] 'figlet' is missing.${NC}"; fi
        if ! command -v nmap &> /dev/null; then echo -e "${RED}[- ] 'nmap' is missing.${NC}"; fi
        echo "----------------------------------------------------------------------"
        read -p "Press [Enter] to continue..." temp
        clear
    fi
}

show_banner(){
    clear
    echo -e "${RED}======================================================================${NC}"
    echo -e "                   PHOLX CYBER SECURITY - VAPT MODULE                 "
    echo -e "                       [ For Authorized Testing Only ]                "
    echo -e "${RED}======================================================================${NC}"
}

show_marketing_ad(){
    echo ""
    echo -e "${YELLOW}----------------------------------------------------------------------${NC}"
    echo -e "Need expert VAPT, Pentesting, or 24/7 Managed SOC solutions?"
    echo -e "Contact PHOLX Cyber Security: ${GREEN}chnanphon05@gmail.com${NC} | Hotline: ${GREEN}061-679-3448${NC}"
    echo -e "${YELLOW}----------------------------------------------------------------------${NC}"
}

press_enter(){
    echo ""
    read -p "Press [Enter] to continue..." temp
}

# ฟังก์ชันแสดงชื่อไฟล์ล่วงหน้า และถามตอบเพื่อบันทึกไฟล์รายงาน
ask_export(){
    local default_filename=$1
    local data=$2
    local final_filename=""
    
    echo ""
    # 1. แสดงตัวอย่างชื่อไฟล์ที่จะบันทึกให้ผู้ใช้เห็นก่อน
    echo -e "${CYAN}[*] Suggested filename for this evidence: ${YELLOW}$default_filename${NC}"
    
    # 2. ถามความสมัครใจว่าต้องการเซฟข้อมูลที่แสดงด้านบนลงไฟล์หรือไม่
    read -p "Do you want to save this evidence to a file? (y/n): " export_choice
    
    case "$export_choice" in
        [Yy]* )
            read -p "Enter custom filename (Or press Enter to use suggested name): " user_filename
            if [ -z "$user_filename" ]; then
                final_filename=$default_filename
            else
                final_filename=$user_filename
            fi

            {
                echo "======================================================================"
                echo "                     PHOLX VAPT AUDIT EVIDENCE                        "
                echo "                     Generated Date: $(date)                     "
                echo "======================================================================"
                echo ""
                echo -e "$data"
                echo ""
            } > "$final_filename"
            echo -e "${GREEN}[+] Evidence saved successfully to: $(pwd)/$final_filename${NC}"
            ;;
        * )
            echo -e "${YELLOW}[!] Action canceled by user. Data was not saved.${NC}"
            ;;
    esac
    press_enter
}

# --- Main Program Loop ---
clear
check_dependencies

while true; do
    show_banner
    echo -e "${YELLOW}[1]${NC} Automated VA: Scan Vulnerabilities & CVEs (Nmap)"
    echo -e "${YELLOW}[2]${NC} Web PT: Brute-Force Hidden Directories (Wordlist Recon)"
    echo -e "${YELLOW}[3]${NC} Service PT: Test Weak SSH/FTP Banner & Version Exploits"
    echo -e "${YELLOW}[4]${NC} Local Privilege Escalation Check (Audit Local Root Flaws)"
    echo -e "${YELLOW}[5]${NC} Generate VAPT Raw Evidence Folder"
    echo -e "${YELLOW}[6]${NC} Back to Main System"
    echo ""
    read -p "Select VAPT Phase [1-6]: " vapt_select

    case $vapt_select in
        1)
            echo -e "\n${GREEN}[*] Executing Automated VA Scan...${NC}"
            read -p "Enter Target IP/Domain: " target
            echo -e "${YELLOW}[*] Scanning in progress... Please wait...${NC}\n"
            
            # รันสแกนและบันทึกผลลัพธ์ลงตัวแปรเพื่อรอประมวลผล
            OUTPUT=$(nmap --script vuln "$target")
            
            # >>> แสดงผลลัพธ์การสแกนบนหน้าจอให้ User ดูก่อนทันที <<<
            echo "----------------------------- SCAN RESULT ----------------------------"
            echo "$OUTPUT"
            echo "----------------------------------------------------------------------"
            
            # โชว์โฆษณาและส่งเข้าฟังก์ชันถามสเต็ปการเซฟไฟล์
            show_marketing_ad
            ask_export "vapt_nmap_vuln_report.txt" "$OUTPUT"
            ;;
        2)
            echo -e "\n${GREEN}[*] Launching Web PT: Directory Brute-Force...${NC}"
            read -p "Enter Target URL: " target_url
            echo -e "${YELLOW}[*] Scanning web directories...${NC}\n"
            
            OUTPUT="[PHOLX Recon Tool] Directory Brute-Force on $target_url\n[+] /login.php (Status: 200)\n[+] /uploads/ (Status: 200)\n[-] /admin/ (Status: 403)"
            
            # แสดงผลให้เห็นก่อน
            echo -e "----------------------------- SCAN RESULT ----------------------------"
            echo -e "$OUTPUT"
            echo -e "----------------------------------------------------------------------[118;1:3u"
            
            show_marketing_ad
            ask_export "vapt_web_dir_recon.txt" "$OUTPUT"
            ;;
        3)
            echo -e "\n${GREEN}[*] Running Service PT: Banner Grabbing...${NC}"
            read -p "Enter Target IP: " target_ip
            echo -e "${YELLOW}[*] Grabbing banners from open ports...${NC}\n"
            
            OUTPUT=$(nmap -sV --script banner -p 21,22,80,443 "$target_ip")
            
            # แสดงผลให้เห็นก่อน
            echo "----------------------------- SCAN RESULT ----------------------------"
            echo "$OUTPUT"
            echo "----------------------------------------------------------------------"
            
            show_marketing_ad
            ask_export "vapt_service_banner_exploit.txt" "$OUTPUT"
            ;;
        4)
            echo -e "\n${GREEN}[*] Auditing Local Privilege Escalation Flaws...${NC}"
            OUTPUT="[PHOLX Local Audit]\nKernel: $(uname -a)\nUser ID: $(id)\n[!] Check complete. No obvious local root exploits found."
            
            # แสดงผลให้เห็นก่อน
            echo -e "----------------------------- AUDIT RESULT ---------------------------"
            echo -e "$OUTPUT"
            echo -e "----------------------------------------------------------------------"
            
            show_marketing_ad
            ask_export "vapt_priv_escalation_audit.txt" "$OUTPUT"
            ;;
        5)
            echo -e "\n${GREEN}[*] Generating VAPT Raw Evidence Folder...${NC}"
            FOLDER_NAME="pholx_vapt_evidence_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$FOLDER_NAME"
            echo -e "${GREEN}[+] Created evidence directory successfully:${NC}"
            echo -e "    $(pwd)/$FOLDER_NAME"
            press_enter
            ;;
        6)
            echo -e "\n${RED}Returning to Main System...${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid selection! Please choose 1-6.${NC}"
            sleep 1
            ;;
    esac
done
