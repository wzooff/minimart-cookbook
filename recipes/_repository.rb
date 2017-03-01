require 'nokogiri'

def github_cookbook_list
  cookbook_repositories = []
  node['minimart']['repositories']['github'].each do |name, repo|
    tag_url = "https://github.com/#{repo}/tags"
    repo_tags = []
    Nokogiri::HTML(Chef::HTTP.new(tag_url).get('/', {})).css('span.tag-name').each do |tag|
      repo_tags << tag.text
    end
    cookbook_repositories << [name.to_s, "https://github.com/#{repo}.git", repo_tags]
  end
  cookbook_repositories
end

cookbook_list = github_cookbook_list

template "#{node['minimart']['path']}/inventory.yml" do
  mode 00744
  variables cookbook_list: cookbook_list
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
  notifies :reload, 'service[nginx]', :delayed
  action :nothing
end
