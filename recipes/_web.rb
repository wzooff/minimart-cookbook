node.default['nginx']['install_method'] = node['minimart']['webserver']['install_method']
node.default['nginx']['source']['version'] = node['minimart']['webserver']['source']['version']

package 'nginx' do
  action :install
end

file '/etc/nginx/nginx.conf' do
  content <<-EOF.gsub(/^ {4}/, '')
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;

    include /usr/share/nginx/modules/*.conf;

    events {
        worker_connections 1024;
    }

    http {
      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';

      access_log  /var/log/nginx/access.log  main;

      sendfile            on;
      tcp_nopush          on;
      tcp_nodelay         on;
      keepalive_timeout   65;
      types_hash_max_size 2048;

      include             /etc/nginx/mime.types;
      default_type        application/octet-stream;

      server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        root #{node['minimart']['path']}/web;
        index index.html index.htm;
        server_name #{node['minimart']['webserver']['domain']};
        location /universe {
          default_type application/json;
        }
      }
    }
  EOF
  notifies :reload, 'service[nginx]', :delayed
end

service 'nginx' do
  subscribes :restart, 'rbenv_script[web]', :delayed
  action [:start, :enable]
end
