curl -# -G "http://199.191.49.179/where/text/stop.action?id=1_26860&route=1_100252"\
 -H "Host: 199.191.49.179"\
 -H "Connection: keep-alive"\
 -H "Cache-Control: max-age=0"\
 -H "Upgrade-Insecure-Requests: 1"\
 -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"\
 -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"\
 -H "Accept-Encoding: gzip, deflate, sdch"\
 -H "Accept-Language: en-US,en;q=0.8,es;q=0.6"\
 -H "Cookie: SPRING_SECURITY_REMEMBER_ME_COOKIE=d2ViX2UzMTA4NTIxLTQ2OTEtNGM4Ni05Y2UyLTQ3MzdlZDNmMGVkOToxNTM1NTc4NzYyNjI3OjhjZjIyYWE5YmVjNzM3NzhlNDY2NjRmMTdiMjAyYWVl; __utma=219493465.1381903583.1472506700.1472506700.1472601437.2; __utmc=219493465; __utmz=219493465.1472506700.1.1.utmcsr=pugetsound.onebusaway.org|utmccn=(referral)|utmcmd=referral|utmcct=/; JSESSIONID=4728AF693EA933B55E76D2F8BA482C03" \
 2> /dev/null \
 | gunzip \
 | html2text \
 | tail -n +5 \
 | head -n -6
