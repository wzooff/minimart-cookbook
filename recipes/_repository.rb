ruby_block 'get_repo_list' do
  block do
    require 'nokogiri'
    require 'git'

    def github_web_list
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

    def github_git_list
      cookbook_repositories = []
      node['minimart']['repositories']['github'].each do |name, repo|
        repo_tags = Git.ls_remote("ssh://git@github.com/#{repo}.git")['tags'].keys.select { |tag| tag =~ /\d$/ }
        cookbook_repositories << [name.to_s, "git@github.com:#{repo}.git", repo_tags] if repo_tags != []
      end
      cookbook_repositories
    end

    cblist = if node['minimart']['repositories']['github_parse'] == 'https'
               github_web_list
             else
               github_git_list
             end
    # oh my... dirty hack to pass array without attributes )
    r = Chef::Resource::Template.new("#{node['minimart']['path']}/inventory.yml.erb", run_context)
    r.path       "#{node['minimart']['path']}/inventory.yml.erb"
    r.source     'inventory.yml.erb'
    r.cookbook   'minimart'
    r.owner      'root'
    r.group      'root'
    r.mode       00600
    r.variables  cookbook_list: cblist
    r.run_action :create
  end
  not_if { node['minimart']['custom_inventory'] }
end

template "#{node['minimart']['path']}/inventory.yml" do
  source "#{node['minimart']['path']}/inventory.yml.erb"
  local true
  owner 'root'
  group 'root'
  mode 00744
  not_if { node['minimart']['custom_inventory'] }
end

bash 'mirror' do
  code 'minimart mirror'
  cwd node['minimart']['path']
  action :nothing
  subscribes :run, "template[#{node['minimart']['path']}/inventory.yml]", :immediately
  notifies :run, 'bash[web]', :immediately
end

bash 'web' do
  code "minimart web --host #{node['minimart']['url']}"
  cwd node['minimart']['path']
  action :nothing
end
