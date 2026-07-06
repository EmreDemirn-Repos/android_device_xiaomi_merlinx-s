#!/system/bin/sh
# c2_fix.sh
# MTK C2 HAL'in "C2_BAD_VALUE" sonsuz döngüsüne veya "slow BM fetch thread"
# durgunluğuna girdiğinde servisi zorla restart eder.

sleep 120
logcat -c
LAST_HIT=0
log -p i -t C2Fix "C2 Fixer (System_Ext) Started."

while true; do
    NOW=$(date +%s)
    HITS=$(logcat -d -t 2000 | grep -cE "C2_BAD_VALUE, bufferqueue may disconnected|slow BM fetch thread")

    if [ "$HITS" -ge 10 ]; then
        if [ $((NOW - LAST_HIT)) -gt 12 ]; then
            log -p w -t C2Fix "C2 stall detected ($HITS hits), restarting C2 HAL"

            # Önce buffer'ı temizle ki restart sonrası eski satırları tekrar sayıp
            # gereksiz ikinci bir restart'a sebep olmasın
            logcat -c

            setprop sys.c2_fix.trigger 1

            LAST_HIT=$NOW

            # Yeni C2 instance'ının sağlıklı ayağa kalkması için dinlenme süresi.
            sleep 5
        fi
    fi
    sleep 3
done
