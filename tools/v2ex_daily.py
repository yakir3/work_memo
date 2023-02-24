"""
# requirements.txt
certifi==2022.6.15
charset-normalizer==2.0.12
idna==3.3
requests==2.27.1
urllib3==1.26.9

# crontab
59 23 * * * source /opt/py3venv/bin/activate; cd /opt/; python v2ex_daily.py &> /tmp/v2ex_daily.log
"""

import sys
import re
import requests
from http import cookiejar as cookielib
import urllib.request as urllib2

V2EX_COOKIE = 'f5dfeaba-3116-4a89-b4ff-f57b32e19b69'
V2EX_DOMAIN = r'v2ex.com'
V2EX_URL_START = r'https://' + V2EX_DOMAIN
V2EX_MISSION = V2EX_URL_START + r'/mission/daily'
V2EX_COIN_URL = r'/mission/daily/redeem?once='

def get_once_url(data):
    p = '/mission/daily/redeem\?once=\d+'
    m = re.search(p, data)
    if m:
        return m.group()
    else:
        return None

def make_cookie(name, value):
    return cookielib.Cookie(
        version=0,
        name=name,
        value=value,
        port=None,
        port_specified=False,
        domain=V2EX_DOMAIN,
        domain_specified=True,
        domain_initial_dot=False,
        path='/',
        path_specified=True,
        secure=False,
        expires=None,
        discard=False,
        comment=None,
        comment_url=None,
        rest=None
    )

if __name__ == '__main__':
    cj = cookielib.CookieJar()
    cj.set_cookie(make_cookie('auth', V2EX_COOKIE))
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))

    opener.addheaders = [
        ('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; rv:20.0) Gecko/20100101 Firefox/20.0'),
        ('Referer', V2EX_MISSION)
    ]

    opener.open(V2EX_URL_START).read()

    data = opener.open(V2EX_MISSION).read()
    once = get_once_url(str(data))
    if None == once:
        print('"once" not found, maybe you already got coins')
        sys.exit(-1)

    v2ex_coin_url = V2EX_URL_START + once
    print(v2ex_coin_url)
    opener.open(v2ex_coin_url).read()
