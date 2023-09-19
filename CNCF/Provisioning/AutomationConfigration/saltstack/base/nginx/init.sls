nginx:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/init.d/nginx
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/fastcgi.conf
      - pkg: nginx
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    - user: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: nginx

/etc/nginx/fastcgi.conf:
  file.managed:
    - source: salt://nginx/files/fastcgi.conf 
    - user: root
    - mode: 644
    - require:
      - pkg: nginx
