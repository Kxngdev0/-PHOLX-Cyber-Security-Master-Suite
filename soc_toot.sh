#!/usr/bin/env bash

# กำหนดรหัสสีสำหรับใช้ใน Terminal
RED='\033[0;31m'    #
GREEN='\033[0;32m'  #
YELLOW='\033[0;33m' #
BLUE='\033[0;34m'   #
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'        # No Color

# ฟังก์ชันตรวจเช็คโปรแกรมที่จำเป็นในเครื่องก่อนรันสคริปต์
check_dependencies() {
    if ! command -v figlet &> /dev/null || ! command -v nmap &> /dev/null; then
        echo -e "${YELLOW}[!] แจ้งเตือน: ตรวจพบว่าเครื่องของคุณยังไม่ได้ติดตั้งโปรแกรมเสริมที่จำเป็น${NC}"
        echo "----------------------------------------------------------------------"
        
        if ! command -v figlet &> /dev/null; then
            echo -e "${RED}[- ] ไม่พบโปรแกรม 'figlet' (ใช้สำหรับแสดงแบนเนอร์ข้อความ)${NC}"
        fi
        
        if ! command -v nmap &> /dev/null; then
            echo -e "${RED}[- ] ไม่พบโปรแกรม 'nmap' (ใช้สำหรับเมนูสแกนช่องโหว่เครือข่าย)${NC}"
        fi
        
        echo "----------------------------------------------------------------------"
        echo -e "${GREEN}[*] วิธีติดตั้งง่ายๆ ก่อนใช้งาน:${NC}"
        if [ "$(uname)" = "Darwin" ]; then
            echo "    สำหรับ Mac (macOS):  brew install figlet nmap"
        else
            echo "    สำหรับ Linux (Ubuntu/Debian): sudo apt update && sudo apt install figlet nmap -y"
        fi
        echo "----------------------------------------------------------------------"
        read -p "กด [Enter] เพื่อรับทราบและเข้าสู่โปรแกรมเบื้องต้น..." temp
        clear
    fi
}

show_banner(){
    echo -e "${RED}" #
    if command -v figlet &> /dev/null; then #
        echo "PHOLX Cyber" | figlet -f "slant"
        echo "Security" | figlet -f "slant"
    else
        echo -e "${RED}=== PHOLX Cyber Security ===${NC}"
    fi
    echo -e "${NC}" #
    echo -e "${BLUE}======================================================================${NC}" #
    echo -e " Developed by : PHOLX.CO.,LTD"
    echo -e " www.pholx.co.th"
    echo -e " 24/7 Incident Hotline: 061-679-3448"
    echo -e "${BLUE}======================================================================${NC}" #
    echo -e "${BLUE} SOC Monitoring Tool v1.0 | $(date)${NC}" #
    echo -e "${BLUE}======================================================================${NC}" #
    echo "" #
}

show_marketing_ad(){
    echo ""
    echo -e "${YELLOW}----------------------------------------------------------------------${NC}"
    echo -e "${RED}[!] ระบบตรวจพบช่องโหว่ หรือมีพอร์ตที่เปิดทิ้งไว้โดยไม่จำเป็น?${NC}"
    echo -e "ให้ทีมวิศวกรความปลอดภัยจาก ${CYAN}PHOLX Cyber Security${NC} เข้าช่วยเหลือ"
    echo -e "เรามีบริการทำ Vulnerability Assessment, Pentest และระบบ Managed SOC 24/7"
    echo -e "ติดต่อสอบถามบริการฟรี: ${GREEN}chnanphon05@gmail.com${NC} หรือโทร: ${GREEN}061-679-3448${NC}"
    echo -e "${YELLOW}----------------------------------------------------------------------${NC}"
}

main_menu(){
    show_banner
    echo -e "${YELLOW}[1]${NC} Check Network Connections (netstat/ss)" #
    echo -e "${YELLOW}[2]${NC} Monitor Failed SSH Logins (Auth Log)" #
    echo -e "${YELLOW}[3]${NC} List Running System Services" #
    echo -e "${YELLOW}[4]${NC} Kill a Suspicious Process (Incident Response)"
    echo -e "${YELLOW}[5]${NC} Network Vulnerability Scanner (Nmap) ${GREEN}[EXPANDED]${NC}"
    echo -e "${YELLOW}[6]${NC} Exit" #
    echo "" #
    read -p "Select an option [1-6]: " select #

    case $select in #
        1)
            echo -e "\n${GREEN}[*] Checking Network Connection.........${NC}" #
            echo "----------------------------------------------------------------------" #
            if command -v ss &> /dev/null; then #
                OUTPUT=$(ss -tulpn | head -n 15) #
            elif command -v netstat &> /dev/null; then #
                OUTPUT=$(netstat -an | grep LISTEN | head -n 15) #
            else
                OUTPUT="Error: Neither 'ss' nor 'netstat' is installed." #
            fi #
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_network_report.txt" "$OUTPUT"
            ;; #
            
        2)
            echo -e "\n${GREEN}[*] System Info (Failed SSH Logins).......${NC}" #
            echo "----------------------------------------------------------------------" #
            if [ "$(uname)" = "Darwin" ]; then #
                OUTPUT=$(log show --predicate 'process == "sshd"' --last 1d | tail -n 10) #
                echo "$OUTPUT" | sed -e "s/Error/${RED}Error${NC}/g" -e "s/Activity/${CYAN}Activity${NC}/g"
            else #
                if [ -f /var/log/auth.log ]; then
                    OUTPUT=$(grep "Failed password" /var/log/auth.log | tail -n 10) #
                elif [ -f /var/log/secure ]; then
                    OUTPUT=$(grep "Failed password" /var/log/secure | tail -n 10)
                else
                    OUTPUT="Log file not accessible (Try running with sudo)" #
                fi
                echo "$OUTPUT"
            fi #
            show_marketing_ad
            ask_export "pholx_ssh_failed_report.txt" "$OUTPUT"
            ;; #
            
        3)
            echo -e "\n${GREEN}[*] Checking Running Services...........${NC}" #
            echo "----------------------------------------------------------------------" #
            if command -v systemctl &> /dev/null; then #
                OUTPUT=$(systemctl list-units --type=service --state=runni[118;1:3ung | head -n 15) #
            elif command -v launchctl &> /dev/null; then #
                OUTPUT=$(launchctl list | head -n 15) #
            else #
                OUTPUT="Error: Service manager not found" #
            fi #
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_services_report.txt" "$OUTPUT"
            ;; #
            
        4)
            echo -e "\n${RED}[!] Incident Response: Kill Process${NC}"
            echo "----------------------------------------------------------------------"
            read -p "Enter PID to kill: " kill_pid
            if [ -z "$kill_pid" ]; then
                echo -e "${YELLOW}Invalid PID.${NC}"
            else
                echo -e "${YELLOW}[*] Attempting to terminate PID: $kill_pid...${NC}"
                kill -15 $kill_pid 2>/dev/null || sudo kill -9 $kill_pid 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[+] Process $kill_pid has been terminated successfully.${NC}"
                else
                    echo -e "${RED}[-] Failed to kill process. Check if PID exists or run as sudo.${NC}"
                fi
            fi
            press_enter
            ;;
            
        5)
            run_nmap_menu
            ;;
            
        6)
            echo -e "\n${RED}Exiting.........Thank you for using PHOLX Security Tool!${NC}\n" #
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option! Please select 1-6.${NC}"
            press_enter
            ;;
    esac
}

run_nmap_menu(){
    clear
    echo -e "${PURPLE}"
    if command -v figlet &> /dev/null; then
        echo "PHOLX Scanner" | figlet -f "slant"
    else
        echo "=== PHOLX Network Scanner ==="
    fi
    echo -e "${NC}"
    echo "----------------------------------------------------------------------"
    
    if ! command -v nmap &> /dev/null; then
        echo -e "${RED}[-] Error: nmap ไม่ได้ถูกติดตั้งในเครื่องนี้${NC}"
        press_enter
        return
    fi

    echo -e "${YELLOW}[1]${NC} Quick Port Scan (Top 100 Common Ports)"
    echo -e "${YELLOW}[2]${NC} Subnet Asset Discovery (Ping Sweep)"
    echo -e "${YELLOW}[3]${NC} Deep Aggressive Scan (OS & App Version Detection) ${RED}*Sudo${NC}"
    echo -e "${YELLOW}[4]${NC} Vulnerability Scan ${GREEN}[NEW]${NC}"
    echo -e "${YELLOW}[5]${NC} Full Port Scan"
    echo -e "${YELLOW}[6]${NC} UDP Port Scan  ${RED}*Sudo${NC}"
    echo -e "${YELLOW}[7]${NC} Back to Main Menu"
    echo ""
    read -p "Select scan profile [1-7]: " nmap_select

    case $nmap_select in
        1)
            read -p "Enter Target IP or Domain: " target
            echo -e "${CYAN}[*] Running Fast Port Scan on $target...${NC}"
            OUTPUT=$(nmap -F "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_quick_scan.txt" "$OUTPUT"
            ;;
        2)
            read -p "Enter Subnet Range (e.g., 192.168.1.0/24): " target
            echo -e "${CYAN}[*] Discovering live assets on subnet $target...${NC}"
            OUTPUT=$(nmap -sn  "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_ping_sweep.txt" "$OUTPUT"
            ;;
        3)
            read -p "Enter Target IP: " target
            echo -e "${CYAN}[*] Running OS & Version Fingerprinting on $target...${NC}"
            OUTPUT=$(sudo nmap -A -T4 "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_aggressive_scan.txt" "$OUTPUT"
            ;;
        4)
            read -p "Enter Target IP or Domain: " target
            echo -e "${CYAN}[*] [PHOLX Audit] Scanning for known vulnerabilities on $target... (Please wait)${NC}"
            OUTPUT=$(nmap --script vuln "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_vuln_report.txt" "$OUTPUT"
            ;;
        5)
            read -p "Enter Target IP: " target
            echo -e "${CYAN}[*] Scanning ALL 65,535 ports on $target... (This may take a few minutes)${NC}"
            OUTPUT=$(nmap -p- -T4 "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_full_port_report.txt" "$OUTPUT"
            ;;
        6)
            read -p "Enter Target IP: " target
            echo -e "${CYAN}[*] Scanning UDP ports on $target... (Sudo required)${NC}"
            OUTPUT=$(sudo nmap -sU --top-ports 20 "$target")
            echo "$OUTPUT"
            show_marketing_ad
            ask_export "pholx_nmap_udp_report.txt" "$OUTPUT"
            ;;
        7)
            clear
            return
            ;;
        *)
            echo -e "${RED}Invalid Option.${NC}"
            sleep 1
            run_nmap_menu
            ;;
    esac
}

press_enter(){
    echo ""
    read -p "Press [Enter] to return to menu....."
    clear
    main_menu
}

ask_export(){
    local filename=$1
    local data=$2
    echo ""
    read -p "Do you want to export this output to a file? (y/n): " export_choice
    
    case "$export_choice" in
        [Yy]* )
            {
                echo "======================================================================"
                echo "                     PHOLX CYBER SECURITY REPORT                      "
                echo "                     Automated Local Security Audit                   "
                echo "                     Date: $(date)                     "
                echo "======================================================================"
                echo ""
                echo "$data"
                echo ""
                echo "======================================================================"
                echo " Need Corporate Security Solutions, VAPT, or Managed SOC?             "
                echo " Website : www.pholx.co.th                                            "
                echo " Email   : chnanphon05@gmail.com                                         "
                echo " Hotline : 061-679-3448                                               "
                echo "======================================================================"
            } > "$filename"
            echo -e "${GREEN}[+] Saved successfully to: $(pwd)/$filename${NC}"
            ;;
        * )
            echo -e "${YELLOW}[*] Cancelled report saving.${NC}"
            ;;
    esac
    press_enter
}

# --- สั่งทำงานเริ่มต้นสคริปต์ ---
clear
check_dependencies
while true; do
    main_menu
done

