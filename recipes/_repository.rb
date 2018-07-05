ruby_block 'get_repo_list' do
  block do
    require 'nokogiri'
    require 'git'

    def github_web_list(github_host, repositories)
      cookbook_repositories = []
      repositories.each do |name, repo|
        tag_url = "https://#{github_host}/#{repo}/tags"
        repo_tags = []
        Nokogiri::HTML(Chef::HTTP.new(tag_url).get('/', {})).css('span.tag-name').each do |tag|
          repo_tags << tag.text
        end
        unless repo_tags == []
          cookbook_repositories << [name.to_s, "https://#{github_host}/#{repo}.git", repo_tags]
        else
          cookbook_repositories << [name.to_s, "https://#{github_host}/#{repo}.git", 'master']
        end
      end
      cookbook_repositories
    end

    def github_git_list
      cookbook_repositories = []
      repositories.each do |name, repo|
        repo_tags = Git.ls_remote("ssh://git@#{github_host}/#{repo}.git")['tags'].keys.select { |tag| tag =~ /\d$/ }
        unless repo_tags == []
          cookbook_repositories << [name.to_s, "git@#{github_host}:#{repo}.git", repo_tags]
        else
          cookbook_repositories << [name.to_s, "git@#{github_host}:#{repo}.git", 'master']
        end
      end
      cookbook_repositories
    end

    cblist = if node['minimart']['repositories']['github_parse'] == 'https'
               github_web_list('github.com', node['minimart']['repositories']['github'])
             else
               github_git_list('github.com', node['minimart']['repositories']['github'])
             end

    unless node['minimart']['repositories']['github_ent_host'].nil?
      ent_cblist = if node['minimart']['repositories']['github_ent_parse'] == 'https'
                 github_web_list(node['minimart']['repositories']['github_ent_host'], node['minimart']['repositories']['github_ent'])
               else
                 github_git_list(node['minimart']['repositories']['github_ent_host'], node['minimart']['repositories']['github_ent'])
               end
    end

    cblist.push(*ent_cblist)

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

rbenv_script 'mirror' do
  rbenv_version node['minimart']['ruby_version']
  if node['minimart']['repositories']['mirror_dependencies']
    code 'minimart mirror --load-deps'
  else
    code 'minimart mirror'
  end
  cwd node['minimart']['path']
  action :nothing
  subscribes :run, "template[#{node['minimart']['path']}/inventory.yml]", :immediately
  notifies :run, 'rbenv_script[web]', :immediately
end

rbenv_script 'web' do
  rbenv_version node['minimart']['ruby_version']
  code "minimart web --host #{node['minimart']['url']}"
  cwd node['minimart']['path']
  action :nothing
end
