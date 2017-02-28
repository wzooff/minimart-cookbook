cookbook_repositories = begin
  Chef::DataBagItem.load('minimart', 'repositories').to_hash
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  nil
end

template "#{node['minimart']['path']}/inventory.yml" do
  owner 'nginx'
  group 'nginx'
  mode 00744
  variables(
    list: cookbook_repositories['list']
  )
  notifies :reload, 'service[nginx]', :delayed
  notifies :run, 'execute[mirror]', :immediately
end

execute 'mirror' do
  command 'minimart mirror'
  cwd node['minimart']['path']
  action :nothing
  notifies :run, 'execute[web]', :immediately
end

execute 'web' do
  command "minimart web --host #{node['minimart']['url']}"
  cwd node['minimart']['path']
  action :nothing
end
