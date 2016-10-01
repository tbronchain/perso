#!/usr/bin/env python3
'''
Test internet connection
'''

import requests, os, time
from requests.exceptions import Timeout

gw_ip='192.168.1.1'
url_test='https://www.google.com'
retries=3

try:
    r = requests.get("http://{0}".format(gw_ip), allow_redirects=False, timeout=10)
except Exception as e:
    print("Gateway unreachable")
    exit(0)

for count in range(0, retries):
    try:
        r = requests.get(url_test, allow_redirects=False, timeout=10)
    except (Timeout) as e:
        print("Connection timeout, retrying")
        continue
    except Exception as e:
        print("Test uri unreachable, rebooting service")
        os.system("ssh root@{0} /etc/init.d/shadowsocks stop".format(gw_ip))
        time.sleep(1)
        os.system("ssh root@{0} /etc/init.d/shadowsocks start".format(gw_ip))
        break
    else:
        print("All good.")
        break

# EOF
