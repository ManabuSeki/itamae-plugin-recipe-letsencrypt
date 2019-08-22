if node[:letsencrypt][:authenticator] == 'webroot' && node[:letsencrypt][:http_server] != nil
  cron_text = <<-EOS
  # DO NOT EDIT
  # BECAUSE THIS CRON CREATE BY itamae-plugin-recipe-letsencrypt
  0 0 1 * * #{node[:letsencrypt][:cron_user]} #{node[:letsencrypt][:certbot_auto_path]} renew && /bin/systemctl reload #{node[:letsencrypt][:http_server]}
  EOS
else
  cron_text = <<-EOS
  # DO NOT EDIT
  # BECAUSE THIS CRON CREATE BY itamae-plugin-recipe-letsencrypt
  0 0 1 * * #{node[:letsencrypt][:cron_user]} #{node[:letsencrypt][:certbot_auto_path]} renew
  EOS
end

file node[:letsencrypt][:cron_file_path] do
  content cron_text
end

service_name = case node[:platform]
              when 'amazon','redhat'
                'crond'
              else
                'cron'
              end

service service_name do
  action :start
end
